module AresMUSH
  class Combatant
    include Mongoid::Document
    include Mongoid::Timestamps
      
    field :name, :type => String
    field :name_upcase, :type => String
    field :combatant_type, :type => String
    field :weapon, :type => String
    field :weapon_specials, :type => Array
    field :armor, :type => String
    field :npc_skill, :type => Integer
    field :npc_damage, :type => Array, :default => []
      
    belongs_to :character, :class_name => "AresMUSH::Character"
    belongs_to :combat, :class_name => "AresMUSH::CombatInstance"

    after_initialize :setup_defaults
        
    def client
      self.character ? self.character.client : nil
    end
      
    def inflict_damage(severity, desc, is_stun)
      if (is_npc?)
        npc_damage << severity
      else
        FS3Combat.inflict_damage(self.character, severity, desc, is_stun)
      end
    end
    
    def total_damage_mod
      if (is_npc?)
        wounds = self.npc_damage.map { |d| Damage.new(current_severity: d)}
      else
        wounds = self.character.damage
      end
      FS3Combat.total_damage_mod(wounds)
    end
    
    def roll_attack(mod)
      # TODO
      # Determine weapon attack stat
      # Stance mod
      # Passed-in mod
      # Damage mod
      # Weapon accuracy mod
      ability = FS3Combat.weapon_stat(self.weapon, "attack_skill")
      roll_ability(ability, mod)
    end
    
    def roll_defense(weapon)
      # TODO
      # Determine weapon defense stat
      # Damage mod
      # Stance mod
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
    
    def is_npc?
      self.character.nil?
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