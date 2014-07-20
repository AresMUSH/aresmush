module AresMUSH
  module Login
    def self.can_access_email?(actor, model)
      return true if actor == model
      return actor.has_any_role?(Global.config["login"]["roles"]["can_access_email"])
    end
    
    def self.can_reset_password?(actor)
      return actor.has_any_role?(Global.config["login"]["roles"]["can_reset_password"])
    end
    
    def self.terms_of_service
      tos_filename = Global.config['connect']['terms_of_service']
      return tos_filename.nil? ? nil : File.read(tos_filename)
    end
    
    def self.wants_announce(listener, connector)
      return false if listener.nil?
      return true if listener.announce == "all"
      return true if listener.room == connector.room
      return false if listener.announce == "none"
      listener.friends.include?(connector)
    end
  end
end