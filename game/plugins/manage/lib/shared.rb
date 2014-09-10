module AresMUSH
  module Manage
    def self.can_manage_game?(actor)
      return false if actor.nil?
      return actor.has_any_role?(Global.config["manage"]["roles"]["can_manage_game"])
    end
    
    def self.can_manage_players?(actor)
      return false if actor.nil?
      return actor.has_any_role?(Global.config["manage"]["roles"]["can_manage_players"])
    end
    
    def self.can_manage_rooms?(actor)
      return false if actor.nil?
      return actor.has_any_role?(Global.config["manage"]["roles"]["can_manage_rooms"])
    end
    
    def self.can_manage_object?(actor, model)
      return false if actor.nil?
      if (model.class == Character)
        self.can_manage_players?(actor)
      elsif (model.class == Room || model.class == Exit)
        self.can_manage_rooms?(actor)
      else
        self.can_manage_game?(actor)
      end
    end
  end
end
