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
        
        errors = Global.plugin_manager.check_plugin_config
        if (errors.any?)
          return t('manage.plugin_config_invalid', :errors => "\n- #{errors.join("\n- ")}")
        end
            
        return nil
      rescue Exception => e
        Global.logger.debug "Error loading config: #{e}"
        return e
      end
    end
    
    def self.announce(msg)
      # Doesn't use notify_ooc because the prompt includes the %%
      formatted_msg = t('manage.announce', :message => msg)
      Channels.announce_notification(formatted_msg)
      Global.notifier.notify(:announcement, formatted_msg) do |char|
        true
      end
    end
    
    def self.is_extra_installed?(name)
      extras = Global.read_config('plugins', 'extras') || []
      extras.include?(name)
    end
    
    def self.server_reboot_required?
      File.exist?('/var/run/reboot-required')
    end
  end
end