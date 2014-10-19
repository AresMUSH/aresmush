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
      return true if listener.watch == "all"
      return false if listener.watch == "none"
      return true if listener.has_friended_char?(connector)
      listener.has_friended_handle?(connector) && connector.handle_visible_to?(listener)
    end
    
    def self.guest_role
      Global.config['login']['guest_role']
    end
    
    def self.is_guest?(char)
      char.has_any_role?(Login.guest_role)
    end
    
    def self.guests
      Character.where(:roles.in => [ Login.guest_role ]).all
    end
  end
end