module AresMUSH
  module Manage
    
    def self.reload_config
      begin
        # Make sure everything is valid before we start.
        Global.config_reader.validate_game_config
        
        Global.logger.debug "Loading game config."
        Global.config_reader.load_game_config
        Global.help_reader.load_game_help
        Global.dispatcher.queue_event ConfigUpdatedEvent.new
        
        return nil
      rescue Exception => e
        Global.logger.debug "Error loading config: #{e}"
        return e
      end
    end
    
    def self.announce(msg)
      # Doesn't use notify_ooc because the prompt includes the %%
      Global.notifier.notify(:announcement, t('manage.announce', :message => msg)) do |char|
        true
      end
    end
  end
end