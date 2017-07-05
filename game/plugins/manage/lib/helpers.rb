module AresMUSH
  module Manage
    def self.can_manage_game?(actor)
      return false if !actor
      actor.has_permission?("manage_game")
    end
    
    def self.can_manage_rooms?(actor)
      return false if !actor
      actor.has_permission?("build") || self.can_manage_game?(actor)
    end
    
    def self.can_manage_object?(actor, model)
      return false if !actor
      if (model.class == Room || model.class == Exit)
        self.can_manage_rooms?(actor)
      else
        self.can_manage_game?(actor)
      end
    end
  end
end
