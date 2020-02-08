module AresMUSH
  module Manage
    
    def self.reload_config
      begin
        # Make sure everything is valid before we start.
        Global.config_reader.validate_game_config
        
        Global.logger.debug "Loading game config."
        Global.config_reader.load_game_config
        Help.reload_help
        Global.dispatcher.queue_event ConfigUpdatedEvent.new
        
        return nil
      rescue Exception => e
        Global.logger.debug "Error loading config: #{e}"
        return e
      end
    end
    
    def self.announce(msg)
      # Doesn't use notify_ooc because the prompt includes the %%
      formatted_msg = t('manage.announce', :message => msg)
      Global.notifier.notify(:announcement, formatted_msg) do |char|
        true
      end
      Channels.announce_notification(formatted_msg)
    end
    
    def self.is_extra_installed?(name)
      extras = Global.read_config('plugins', 'extras') || []
      extras.include?(name)
    end
  end
end