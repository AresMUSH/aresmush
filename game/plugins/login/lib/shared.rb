module AresMUSH
  module Login
    def self.can_access_email?(actor, model)
      return true if actor == model
      return actor.has_any_role?(Global.config["login"]["roles"]["can_access_email"])
    end
    
    def self.can_reset_password?(actor)
      return actor.has_any_role?(Global.config["login"]["roles"]["can_reset_password"])
    end
  end
end