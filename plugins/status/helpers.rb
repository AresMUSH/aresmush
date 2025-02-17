module AresMUSH
  module Status
    def self.can_be_on_duty?(actor)
      actor && actor.has_permission?("set_duty")
    end

    def self.can_manage_status?(actor)
      actor && actor.has_permission?("manage_status")
    end
    
    def self.get_icloc(char, reset = false)
      icloc = char.last_ic_location
      if (!icloc || reset)
        icloc = Status.custom_ic_start_location(char) || Rooms.ic_start_room
      end
      icloc
    end
    
    def self.calculate_is_idle(idle_secs)
      minutes_before_idle = "#{Global.read_config("status", "minutes_before_idle")}".to_i
      return false if !minutes_before_idle
      return idle_secs > minutes_before_idle * 60
    end
  end
end