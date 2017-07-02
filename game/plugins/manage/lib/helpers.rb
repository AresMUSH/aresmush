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
        Global.help_reader.load_game_help
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
