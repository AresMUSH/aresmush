module AresMUSH
  
  class Combatant < Ohm::Model
    include ObjectModel
      
    attribute :action_klass
    attribute :action_args    
    attribute :combatant_type
    attribute :weapon_name
    attribute :mount_type
    attribute :weapon_specials, :type => DataType::Array, :default => []
    attribute :armor_specials, :type => DataType::Array, :default => []
    attribute :prior_ammo, :type => DataType::Hash, :default => {}
    attribute :stance, :default => "Normal"
    attribute :armor_name
    attribute :is_ko, :type => DataType::Boolean
    attribute :idle, :type => DataType::Boolean
    attribute :luck
    attribute :ammo, :type => DataType::Integer
    attribute :max_ammo, :type => DataType::Integer, :default => 0
    attribute :posed, :type => DataType::Boolean
    attribute :recoil, :type => DataType::Integer, :default => 0
    attribute :team, :type => DataType::Integer, :default => 1
    attribute :stress, :type => DataType::Integer, :default => 0
    attribute :freshly_damaged, :type => DataType::Boolean, :default => false
    
    attribute :damage_lethality_mod, :type => DataType::Integer, :default => 0
    attribute :defense_mod, :type => DataType::Integer, :default => 0
    attribute :attack_mod, :type => DataType::Integer, :default => 0
    attribute :initiative_mod, :type => DataType::Integer, :default => 0
        
    reference :subdued_by, "AresMUSH::Combatant"
    reference :aim_target, "AresMUSH::Combatant"
    reference :character, "AresMUSH::Character"
    reference :combat, "AresMUSH::Combat"
    reference :npc, "AresMUSH::Npc"

    reference :piloting, "AresMUSH::Vehicle"
    reference :riding_in, "AresMUSH::Vehicle"
    
    attribute :damaged_by, :type => DataType::Array, :default => []

    # DEPRECATED - Do Not Use
    attribute :distraction

        
    before_delete :cleanup
        
    def cleanup
      self.clear_mock_damage
      self.npc.delete if self.npc
    end
    
    def weapon
      specials = self.weapon_specials || []
      special_text = specials.empty? ? nil : "+#{specials.join("+")}"
      "#{self.weapon_name}#{special_text}"
    end
    
    def armor
      specials = self.armor_specials || []
      special_text = specials.empty? ? nil : "+#{specials.join("+")}"
      "#{self.armor_name}#{special_text}"
    end
    
    def action
      return nil if !self.action_klass
      klass = FS3Combat.const_get(self.action_klass)
      a = klass.new(self, self.action_args)
      error = a.prepare
      
      if (error)
        self.combat.log "Action Reset: #{self.name} #{self.action_klass} #{self.action_args} #{error}"
        FS3Combat.emit_to_combat self.combat, t('fs3combat.resetting_action', :name => self.name, :error => error)
        self.update(action_klass: nil)
        self.update(action_args: nil)
        return nil
      end
      a
    end
      
    def is_subdued?
      self.subdued_by && self.subdued_by.is_subduing?(self)
    end
    
    def is_subduing?(target)
      self.action && self.action.class == FS3Combat::SubdueAction && self.action.targets && self.action.target == target
    end
    
    def is_passing?
      !self.action || self.action.class == FS3Combat::PassAction
    end
    
    def is_aiming?
      !!self.aim_target
    end
    
    def associated_model
      is_npc? ? self.npc : self.character
    end
    
    def name
      is_npc? ? self.npc.name : self.character.name
    end
    
    def roll_ability(ability, mod = 0)
      result = is_npc? ? self.npc.roll_ability(ability, mod) : self.character.roll_ability(ability, mod)
      successes = result[:successes]
      log("#{self.name} rolling #{ability}: #{successes} successes")
      successes
    end
    
    def add_stress(points)
      points = [ self.stress + points, 5 ].min
      self.update(stress: points)
    end
    
    def client
      self.character ? Login.find_client(self.character) : nil
    end
    
    # NOTE!  This is reported as a negative number.
    def total_damage_mod
      if (is_in_vehicle?)
        FS3Combat.total_damage_mod(self.associated_model) + FS3Combat.total_damage_mod(self.vehicle)
      else
        FS3Combat.total_damage_mod(self.associated_model)
      end
    end

    def inflict_damage(severity, desc, is_stun = false, is_crew_hit = false)
      if (self.is_in_vehicle? && !is_crew_hit)
        model = self.vehicle
      else
        model = self.associated_model
      end
      FS3Combat.inflict_damage(model, severity, desc, is_stun, !self.combat.is_real)
    end
      
    def attack_stance_mod
      stance_config = FS3Combat.stances[self.stance]
      return 0 if !stance_config
      stance_config["attack_mod"]
    end
    
    def defense_stance_mod
      stance_config = FS3Combat.stances[self.stance]
      return 0 if !stance_config
      stance_config["defense_mod"]
    end
    
    def clear_mock_damage
      # Paranoia - should never happen unless there's a bug, but if it does happen it'll
      # prevent us from deleting the object.  So guard against it.
      if (!self.npc && !self.character)
        return
      end
      
      wounds = self.is_npc? ? self.npc.damage : self.character.damage
      wounds.each do |d|
        if (d.is_mock)
          d.delete
        end
      end
    end
    
    def vehicle
      self.piloting ? self.piloting : self.riding_in
    end
    
    def is_in_vehicle?
      self.piloting || self.riding_in
    end
        
    def is_npc?
      !!self.npc
    end
    
    def is_player?
      !self.npc
    end
    
    def is_noncombatant?
      self.combatant_type == "Observer"
    end
    
    def poss_pronoun
      self.is_npc? ? Demographics.possessive_pronoun(nil) : Demographics.possessive_pronoun(self.character)
    end
    
    def log(msg)
      self.combat.log(msg)
    end
  end
end