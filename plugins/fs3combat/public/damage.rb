module AresMUSH
  
  class Damage < Ohm::Model
    include ObjectModel

    attribute :current_severity
    attribute :initial_severity
    attribute :healed, :type => DataType::Boolean
    attribute :ictime_str
    attribute :healing_points, :type => DataType::Integer
    attribute :description
    attribute :is_stun, :type => DataType::Boolean
    attribute :is_mock, :type => DataType::Boolean
  
    reference :character, "AresMUSH::Character"
    reference :npc, "AresMUSH::Npc"
    reference :vehicle, "AresMUSH::Vehicle"

    def is_stun?
      is_stun
    end
  
    def is_treatable?
      return false if self.healed
      time_to_go = (86400) - (Time.now - self.created_at)
      return true if time_to_go > 0
      return false
    end
  
    def wound_mod
      config = Global.read_config("fs3combat", "damage_mods")
      mod = config[self.current_severity]
      mod = mod / 3.0 if self.healed
      mod
    end
  end
end