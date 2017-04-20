module AresMUSH
  module Status
    def self.can_be_on_duty?(actor)
      actor.has_permission?("set_duty")
    end

    def self.can_manage_status?(actor)
      actor.has_permission?("manage_status")
    end
    
    def self.status_color(status)
      status = status.upcase
      config = Global.read_config("status", "colors")
      return config[status] if config.has_key?(status)
      return ""
    end
    
    def self.is_idle?(client)
      minutes_before_idle = Global.read_config("status", "minutes_before_idle")
      return false if !minutes_before_idle
      return client.idle_secs > minutes_before_idle * 60
    end
  end
end