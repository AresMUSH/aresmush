module AresMUSH
  module Manage
    class LoadConfigCmd
      include CommandHandler
      include CommandRequiresLogin
      
      def want_command?(client, cmd)
        cmd.root_is?("load") && cmd.args == "config"
      end
      
      def check_can_manage
        return t('dispatcher.not_allowed') if !Manage.can_manage_game?(client.char)
        return nil
      end

      def handle
        begin
          # Make sure everything is valid before we start.
          Global.config_reader.validate_game_config
          Global.plugin_manager.plugins.each do |p|
            Global.plugin_manager.validate_plugin_config p          
          end
            
          Global.config_reader.clear_config            
          Global.config_reader.load_game_config            
          Global.plugin_manager.plugins.each do |p|
            Global.plugin_manager.load_plugin_config p
          end
          Global.dispatcher.queue_event ConfigUpdatedEvent.new
          
          client.emit_success t('manage.config_loaded')
        rescue Exception => e
          Global.logger.debug "Error loading config: #{e}"
          client.emit_failure t('manage.error_loading_config', :error => e)
        end
      end
      
    end
  end
end
