module AresMUSH
  module Manage
    
    def self.reload_config
      begin
        # Make sure everything is valid before we start.
        Global.config_reader.validate_game_config
        
        Global.config_reader.clear_config
        Global.logger.debug "Loading game config."
        Global.config_reader.load_game_config
        Global.help_reader.load_game_help
        Engine.dispatcher.queue_event ConfigUpdatedEvent.new
        
        return nil
      rescue Exception => e
        Global.logger.debug "Error loading config: #{e}"
        return e
      end
    end
  end
end