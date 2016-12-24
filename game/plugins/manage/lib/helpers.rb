module AresMUSH
  module Manage
    def self.can_manage_game?(actor)
      return false if !actor
      can_manage = true
      
      # This prevents you from getting in a situation where you mess up your role config and then
      # can't fix it without shutting down the game.  If we can't read the roles, we warn you and
      # just assume anyone can access management commands.
      AresMUSH.with_error_handling(nil, "Your game configuration is not secure.  Anyone can access admin commands.") do
        can_manage = actor.has_any_role?(Global.read_config("manage", "can_manage_game"))
      end
      can_manage
    end
    
    def self.can_manage_players?(actor)
      return false if !actor
      return actor.has_any_role?(Global.read_config("manage", "can_manage_players"))
    end
    
    def self.can_manage_rooms?(actor)
      return false if !actor
      return actor.has_any_role?(Global.read_config("manage", "can_manage_rooms"))
    end
    
    def self.can_manage_object?(actor, model)
      return false if !actor
      if (model.class == Character)
        self.can_manage_players?(actor)
      elsif (model.class == Room || model.class == Exit)
        self.can_manage_rooms?(actor)
      else
        self.can_manage_game?(actor)
      end
    end
    
    def self.reload_config
      begin
        # Make sure everything is valid before we start.
        Global.config_reader.validate_game_config
        Global.plugin_manager.plugins.each do |p|
          Global.plugin_manager.validate_plugin_config p          
        end
          
        Global.config_reader.clear_config
        Global.logger.debug "Loading game config."
        Global.config_reader.load_game_config
        Global.plugin_manager.plugins.each do |p|
          Global.logger.debug "Loading plugin config for #{p}."
          Global.plugin_manager.load_plugin_config p
        end
        Global.dispatcher.queue_event ConfigUpdatedEvent.new
        
        return nil
      rescue Exception => e
        Global.logger.debug "Error loading config: #{e}"
        return e
      end
    end
  end
end
