module AresMUSH
  module Manage
    class LoadLocaleCmd
      include CommandHandler
      
      def check_can_manage
        return t('dispatcher.not_allowed') if !Manage.can_manage_game?(enactor)
        return nil
      end

      def handle
        begin
          Global.locale.reset_load_path
          Global.plugin_manager.plugins.each do |p|
            Global.plugin_manager.load_plugin_locale p
          end
          Global.locale.reload
          client.emit_success t('manage.locale_loaded')
        rescue Exception => e
          client.emit_failure t('manage.error_loading_locale', :error => e.to_s)
        end
      end
    end
  end
end
