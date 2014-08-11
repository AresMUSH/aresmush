module AresMUSH
  module Status
    
    def self.set_status(char, status)
      char.status = status
      if (status != "AFK")
        char.afk_message = nil
      end
      char.save
    end
  
    def self.can_be_on_duty?(actor)
      actor.has_any_role?(Global.config["status"]["roles"]["can_be_on_duty"])
    end
  end
end