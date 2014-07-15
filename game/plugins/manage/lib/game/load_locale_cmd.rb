module AresMUSH
  module Manage
    class LoadLocaleCmd
      include Plugin
      include PluginRequiresLogin
      
      def want_command?(client, cmd)
        cmd.root_is?("load") && cmd.args == "locale"
      end
      
      def check_can_manage
        return t('dispatcher.not_allowed') if !Manage.can_manage?(client.char)
        return nil
      end

      def handle
        begin
          Global.locale.load!
          client.emit_success t('manage.locale_loaded')
        rescue Exception => e
          client.emit_failure t('manage.error_loading_locale', :error => e.to_s)
        end
      end
    end
  end
end
