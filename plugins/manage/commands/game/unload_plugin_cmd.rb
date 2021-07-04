module AresMUSH
  module Manage
    class UnloadPluginCmd
      include CommandHandler
      
      attr_accessor :load_target
      
      def parse_args
        self.load_target = cmd.args
      end
      
      def required_args
        [ self.load_target ]
      end
      
      def check_can_manage
        return t('dispatcher.not_allowed') if !Manage.can_manage_game?(enactor)
        return nil
      end

      def handle
        begin
          Global.plugin_manager.unload_plugin(load_target)
          Global.config_reader.load_game_config
          Help.reload_help
          Global.locale.reload
          
          client.emit_success t('manage.plugin_unloaded', :name => load_target)
        rescue SystemNotFoundException => e
          client.emit_failure t('manage.plugin_not_found', :name => load_target)
        rescue Exception => e
          client.emit_failure t('manage.error_unloading_plugin', :name => load_target, :error => e.to_s)
        end
      end
    end
  end
end
