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
          Global.config_reader.load_game_config
          Global.plugin_manager.plugins.each do |p|
            Global.config_reader.load_plugin_config(p.plugin_dir, p.help_files)
          end
          
          client.emit_success t('manage.config_loaded')
        rescue Exception => e
          client.emit_failure t('manage.error_loading_config', :error => e.to_s)
        end
      end
      
    end
  end
end
