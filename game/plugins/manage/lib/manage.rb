module AresMUSH
  module Manage
    def self.can_manage_game?(actor)
      return false if actor.nil?
      can_manage = true
      
      # This prevents you from getting in a situation where you mess up your role config and then
      # can't fix it without shutting down the game.  If we can't read the roles, we warn you and
      # just assume anyone can access management commands.
      AresMUSH.with_error_handling(nil, "Your game configuration is not secure.  Anyone can access admin commands.") do
        can_manage = actor.has_any_role?(Global.read_config("manage", "roles", "can_manage_game"))
      end
      can_manage
    end
    
    def self.can_manage_players?(actor)
      return false if actor.nil?
      return actor.has_any_role?(Global.read_config("manage", "roles", "can_manage_players"))
    end
    
    def self.can_manage_rooms?(actor)
      return false if actor.nil?
      return actor.has_any_role?(Global.read_config("manage", "roles", "can_manage_rooms"))
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
