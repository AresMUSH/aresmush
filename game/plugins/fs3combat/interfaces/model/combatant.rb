module AresMUSH

  
  class Combatant
    include SupportingObjectModel
      
    field :name, :type => String
    field :name_upcase, :type => String
    field :combatant_type, :type => String
    field :weapon, :type => String
    field :weapon_specials, :type => Array
    field :stance, :type => String, :default => "Normal"
    field :armor, :type => String
    field :npc_skill, :type => Integer
    field :is_ko, :type => Boolean
    field :is_aiming, :type => Boolean
    field :aim_target, :type => String
    field :luck, :type => String
    field :ammo, :type => Integer
    field :posed, :type => Boolean
    field :recoil, :type => Integer, :default => 0
    field :team, :type => Integer, :default => 1
    field :npc_damage, :type => Array, :default => []
      
    belongs_to :character, :class_name => "AresMUSH::Character"
    belongs_to :combat, :class_name => "AresMUSH::CombatInstance"

    has_one :action, :class_name => 'AresMUSH::CombatAction', :inverse_of => :combatant, :dependent => :destroy
    has_and_belongs_to_many :targeted_by_actions, :class_name => 'AresMUSH::CombatAction', :inverse_of => :targets
    
    belongs_to :piloting, :class_name => 'AresMUSH::Vehicle', :inverse_of => :pilot
    belongs_to :riding_in, :class_name => 'AresMUSH::Vehicle', :inverse_of => :passengers
      
    after_initialize :setup_defaults
        
    def client
      self.character ? self.character.client : nil
    end
      
    def total_damage_mod
      if (is_npc?)
        wounds = self.npc_damage.map { |d| Damage.new(current_severity: d)}
      else
        wounds = self.character.damage
      end
      FS3Combat.total_damage_mod(wounds)
    end
    
    def roll_attack(mod = 0)
      ability = FS3Combat.weapon_stat(self.weapon, "skill")
      accuracy_mod = FS3Combat.weapon_stat(self.weapon, "accuracy")
      damage_mod = total_damage_mod
      stance_mod = attack_stance_mod
      aiming_mod = (self.is_aiming && (self.aim_target == self.action.print_target_names)) ? 3 : 0
      luck_mod = (self.luck == "Attack") ? 3 : 0
      mod = mod + accuracy_mod - damage_mod + stance_mod + aiming_mod + luck_mod
      
      Global.logger.debug "Attack roll for #{self.name} ability=#{ability} aiming=#{aiming_mod} mod=#{mod} accuracy=#{accuracy_mod} damage=#{damage_mod} stance=#{stance_mod} luck=#{luck_mod}"
      
      roll_ability(ability, mod)
    end
    
    def roll_defense(attacker_weapon)
      ability = weapon_defense_skill(attacker_weapon)
      stance_mod = defense_stance_mod
      luck_mod = (self.luck == "Defense") ? 3 : 0
      mod = 0 - total_damage_mod + stance_mod + luck_mod
      
      Global.logger.debug "Defense roll for #{self.name} ability=#{ability} stance=#{stance_mod} luck=#{luck_mod}"
      
      roll_ability(ability, mod)
    end
    
    def attack_stance_mod
      case self.stance
      when "Banzai"
        3
      when "Evade"
        -3
      when "Cautious"
        -1
      else
        0
      end
    end
    
    def defense_stance_mod
      case self.stance
      when "Banzai"
        -3
      when "Evade"
        3
      when "Cautious"
        1
      else
        0
      end
    end
    
    # Attacker           |  Defender            |  Skill
    # -------------------|----------------------|----------------------------
    # Any weapon         |  Pilot type          |  Pilot's vehicle skill
    # Any weapon         |  Passenger type      |  Pilot's vehicle skill
    # Melee weapon       |  Melee weapon        |  Defender's weapon skill
    # Melee weapon       |  Other weapon        |  Default combatant type skill
    # Other weapon       |  Other weapon        |  Default combatant type skill
    def weapon_defense_skill(attacker_weapon)
      # TODO - pilot and passenger vehicle skills
      attacker_weapon_type = FS3Combat.weapon_stat(attacker_weapon, "weapon_type").titleize
      defender_weapon_type = FS3Combat.weapon_stat(self.weapon, "weapon_type").titleize
      if (attacker_weapon_type == "Melee" && defender_weapon_type == "Melee")
        skill = FS3Combat.weapon_stat(self.weapon, "skill")
      else
        skill = FS3Combat.combatant_type_stat(self.combatant_type, "defense_skill")
      end
      skill
    end
    
    def hitloc_chart
      # TODO - If combatant is pilot or passenger, use their vehicle's hitloc chart
      #  except for crew hits - maybe pass in a crew_hit bool?
      hitloc_type = FS3Combat.combatant_type_stat(self.combatant_type, "hitloc")
      FS3Combat.hitloc(hitloc_type)["areas"]
    end
    
    def hitloc_severity(hitloc)
      hitloc_type = FS3Combat.combatant_type_stat(self.combatant_type, "hitloc")
      hitloc_data = FS3Combat.hitloc(hitloc_type)
      vital_areas = hitloc_data["vital_areas"]
      crit_areas = hitloc_data["critical_areas"]
      
      return "Vital" if vital_areas.map { |v| v.titleize }.include?(hitloc.titleize)
      return "Critical" if crit_areas.map { |c| c.titleize }.include?(hitloc.titleize)
      return "Normal"
    end
    
    def determine_hitloc(successes)
      roll = rand(hitloc_chart.count) + successes
      roll = [roll, hitloc_chart.count - 1].min
      roll = [0, roll].max
      hitloc_chart[roll]
    end
    
    def roll_ability(ability, mod = 0)
      if (is_npc?)
        result = FS3Skills.one_shot_die_roll(self.npc_skill + mod)
      else
        params = FS3Skills::RollParams.new(ability, mod)
        result = FS3Skills.one_shot_roll(nil, self.character, params)
      end
      result[:successes]
    end
      
    def roll_initiative(ability)
      luck_mod = self.luck == "Initiative" ? 3 : 0
      roll1 = roll_ability(ability, -total_damage_mod)
      roll2 = roll_ability(ability, -total_damage_mod)
      roll1 + roll2 + luck_mod
    end
    
    def do_damage(severity, weapon, hitloc)
      if (is_npc?)
        self.npc_damage << severity
      else
        desc = "#{weapon} - #{hitloc}"
        is_stun = FS3Combat.weapon_is_stun?(weapon)
        FS3Combat.inflict_damage(self.character, severity, desc, is_stun, !self.combat.is_real)
      end
    end
    
    def determine_armor(hitloc, weapon)
      # TODO - If pilot or passenger, use vehicle armor
      
      # Not wearing armor at all.
      return 0 if !self.armor
      
      pen = FS3Combat.weapon_stat(weapon, "penetration")
      protect = FS3Combat.armor_stat(self.armor, "protection")[hitloc]
      
      # Armor doesn't cover this hit location
      return 0 if !protect

      pen_ratio = pen / protect
      
      # No coverage if penetration is way higher than armor value.
      return 0 if pen_ratio > 2
      
      # Full coverage if protection way higher than penetration
      return 100 if pen_ratio < 0.5
       
      # Ratio is between 0.5 (good) and 2 (bad).  Dividing a rand number by
      # that value will give us a number from 50-200.
      return rand(100) / pen_ratio
    end
    
    def determine_damage(hitloc, weapon, armor = 0)
      random = rand(100)
      
      lethality = FS3Combat.weapon_stat(weapon, "lethality")
      
      case hitloc_severity(hitloc)
      when "Critical"
        severity = 30
      when "Vital"
        severity = 15
      else
        severity = 0
      end
      
      total = random + severity + lethality - armor
      
      if (total < 41)
        damage = "L"
      elsif (total < 81)
        damage = "M"
      elsif (total <100)
        damage = "S"
      else
        damage = "C"
      end
      
      Global.logger.info "Determined damage: loc=#{hitloc} sev=#{severity} wpn=#{weapon}" +
      " lth=#{lethality} arm=#{armor} rand=#{random} total=#{total} dmg=#{damage}"
      
      damage
    end
    
    def attack_target(target, called_shot = nil, mod = 0)
      attack_roll = self.roll_attack(mod - self.recoil)
      defense_roll = target.roll_defense(self.weapon)
            
      # Margin of success for the attacker
      margin = attack_roll - defense_roll
            
      if (attack_roll <= 0)
        message = t('fs3combat.attack_missed', :name => self.name, :target => target.name)

      elsif (defense_roll > attack_roll)
        message = t('fs3combat.attack_dodged', :name => self.name, :target => target.name)

      elsif (target.stance == "Cover" && margin < 2 && rand(100) < 60)
        message = t('fs3combat.attack_hits_cover', :name => self.name, :target => target.name)

      else
                  
        # Called shot either hits the desired location, or chooses a random location
        # at a penalty for missing.
        if (called_shot)
          if (margin > 2)
            hitloc = called_shot
          else
            hitloc = target.determine_hitloc(margin - 2)
          end
        else
          hitloc = target.determine_hitloc(margin)
        end
        
        armor = target.determine_armor(hitloc, self.weapon)
        
        if (armor >= 100)
          message = t('fs3combat.attack_stopped_by_armor', :name => self.name, :target => target.name, :hitloc => hitloc)
        else
          
          reduced_by_armor = armor > 0 ? t('fs3combat.reduced_by_armor') : ""
          
          damage = target.determine_damage(hitloc, self.weapon, armor)
          target.do_damage(damage, self.weapon, hitloc)
          message = t('fs3combat.attack_hits', 
            :name => self.name, 
            :target => target.name,
            :hitloc => hitloc,
            :armor => reduced_by_armor,
            :damage => FS3Combat.display_severity(damage)) 
        end
      end
      
      self.recoil = self.recoil + FS3Combat.weapon_stat(self.weapon, "recoil")
      
      message
    end

    def update_ammo(bullets)
      if (self.ammo)
        self.ammo = self.ammo - bullets
        
        if (self.ammo == 0)
          t('fs3combat.weapon_clicks_empty', :name => self.name)
        else
          nil
        end
      end
    end
    
    def clear_mock_damage
      if is_npc?
        self.npc_damage = []
      else
        self.character.damage.each do |d|
          if (d.is_mock)
            d.destroy!
          end
        end
      end
    end
    
    def vehicle
      self.piloting ? self.piloting : self.riding_in
    end
    
    def is_in_vehicle?
      !self.piloting.nil? || !self.riding_in.nil?
    end
        
    def is_npc?
      self.character.nil?
    end
    
    def is_noncombatant?
      self.combatant_type == "Observer"
    end
    
    def poss_pronoun
      is_npc? ? t('demographics.other_possessive') : self.character.possessive_pronoun
    end
    
    def emit(message)
      return if !client
      client_message = message.gsub(/#{name}/, "%xh%xy#{name}%xn")
      client.emit t('fs3combat.combat_emit', :message => client_message)
    end
    
    private
    def setup_defaults
      self.name_upcase = self.name.nil? ? "" : self.name.upcase
      self.npc_skill = self.npc_skill || (rand(3) + 3)
    end
  end
end