module AresMUSH
  module Manage
    class ConfigCheckCmd
      include CommandHandler

      def check_can_manage
        return t('dispatcher.not_allowed') if !Manage.can_manage_game?(enactor)
        return nil
      end
            
      def handle
        begin
          Global.config_reader.validate_game_config          
        rescue Exception => ex
          client.emit_failure t('manage.game_config_invalid', :error => ex)
          return
        end
        errors = Global.plugin_manager.check_plugin_config
        if (errors.any?)
          client.emit_failure t('manage.game_config_invalid', :error => "\n- #{errors.join("\n- ")}")
          return
        end
        
        client.emit_success t('manage.game_config_ok')
      end
    end
  end
end