module AresMUSH
  
  class Damage < Ohm::Model
    include ObjectModel

    attribute :current_severity
    attribute :initial_severity
    attribute :last_treated, :type => DataType::Time
    attribute :ictime, :type => DataType::Time
    attribute :healing_points, :type => DataType::Integer
    attribute :description
    attribute :is_stun, :type => DataType::Boolean
    attribute :is_mock, :type => DataType::Boolean
  
    reference :character, "AresMUSH::Character"

    def is_stun?
      is_stun
    end
  
    def is_treatable?
      return true if !self.last_treated
      time_to_go = 86400 - (Time.now - self.last_treated)
      return true if time_to_go < 0
      return false
    end
  
    def wound_mod
      config = Global.read_config("fs3combat", "damage_mods")
      mod = config[self.current_severity]
      mod = mod / 2 if self.last_treated
      mod
    end
  end
end