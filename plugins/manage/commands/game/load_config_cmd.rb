module AresMUSH
  module Manage
    class LoadConfigCmd
      include CommandHandler
      
      def check_can_manage
        return t('dispatcher.not_allowed') if !Manage.can_manage_game?(enactor)
        return nil
      end

      def handle
        begin
          # Make sure everything is valid before we start.
          Global.config_reader.validate_game_config          
        rescue Exception => ex
          client.emit_failure t('manage.game_config_invalid', :error => ex)
          return
        end
        
        error = Manage.reload_config
        if (error)
          client.emit_failure t('manage.error_loading_config', :error => error)
        else
          client.emit_success t('manage.config_loaded')
        end
      end
      
    end
  end
end
