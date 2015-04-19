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
      
    belongs_to :character, :class_name => "AresMUSH::Character"
    belongs_to :combat, :class_name => "AresMUSH::CombatInstance"

    before_validation :save_upcase_name
      
    def client
      self.character ? self.character.client : nil
    end
      
    def total_damage_mod
      self.character ? FS3Combat.total_damage_mod(self.character.damage) : 99
    end
    
    def is_npc?
      !self.character.nil?
    end
    
    def emit(message)
      return if !client
      client_message = message.gsub(/#{name}/, "%xh%xy#{name}%xn")
      client.emit t('fs3combat.combat_emit', :message => client_message)
    end
    
    private
    def save_upcase_name
      self.name_upcase = self.name.nil? ? "" : self.name.upcase
    end
  end
end