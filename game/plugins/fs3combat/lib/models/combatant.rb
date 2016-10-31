module AresMUSH
  
  class Combatant < Ohm::Model
    include ObjectModel
      
    attribute :action_klass
    attribute :action_args    
    attribute :combatant_type
    attribute :weapon
    attribute :weapon_specials, :type => DataType::Array
    attribute :stance, :default => "Normal"
    attribute :armor
    attribute :is_ko, :type => DataType::Boolean
    attribute :luck
    attribute :ammo, :type => DataType::Integer
    attribute :posed, :type => DataType::Boolean
    attribute :recoil, :type => DataType::Integer, :default => 0
    attribute :team, :type => DataType::Integer, :default => 1

    reference :aim_target, "AresMUSH::Character"
    reference :character, "AresMUSH::Character"
    reference :combat, "AresMUSH::Combat"
    reference :npc, "AresMUSH::Npc"

    reference :piloting, "AresMUSH::Vehicle"
    reference :riding_in, "AresMUSH::Vehicle"
    
    before_delete :cleanup
    
    def cleanup
      self.clear_mock_damage
      self.npc.delete if self.npc
      self.vehicle.delete if self.vehicle
    end
    
    def action
      return nil if !self.action_klass
      klass = FS3Combat.const_get(self.action_klass)
      a = klass.new(self, self.action_args)
      a.prepare
      a
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
      result[:successes]
    end
    
    def targeted_by
      # TODO!!!!
    end
    
    def client
      self.character ? self.character.client : nil
    end
    
    def total_damage_mod
      FS3Combat.total_damage_mod(self.associated_model)
    end

    def inflict_damage(severity, desc, is_stun = false)
      FS3Combat.inflict_damage(self.associated_model, severity, desc, is_stun, !self.combat.is_real)
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
    
    def clear_mock_damage
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
    
    def is_noncombatant?
      self.combatant_type == "Observer"
    end
    
    def poss_pronoun
      self.is_npc? ? t('demographics.other_possessive') : Demographics::Api.possessive_pronoun(self.character)
    end
    
    def emit(message)
      return if !self.client
      client_message = message.gsub(/#{self.name}/, "%xh%xc#{self.name}%xn")
      client.emit t('fs3combat.combat_emit', :message => client_message)
    end
  end
end