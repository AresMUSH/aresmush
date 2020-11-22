module AresMUSH
  module Manage
    class PluginInstallCmd
      include CommandHandler
      
      attr_accessor :url
      
      def parse_args
        self.url = trim_arg(cmd.args)
      end
      
      def required_args
        [ self.url ]
      end
      
      def check_can_manage
        return t('dispatcher.not_allowed') if !Manage.can_manage_game?(enactor)
        return nil
      end
      
      def handle        
        begin
          importer = AresMUSH::Manage::PluginImporter.new(self.url)
          importer.import
          plugin_name = importer.plugin_name
          Global.config_reader.load_game_config
          Global.plugin_manager.load_plugin(plugin_name)      
          Help.reload_help
          Global.locale.reload
          Global.dispatcher.queue_event ConfigUpdatedEvent.new                
          Website.redeploy_portal(enactor, false)
          client.emit_success t('manage.plugin_installed', :name => plugin_name, :url => self.url)
        rescue Exception => e
          Global.logger.debug "Error instaling plugin: #{e}  backtrace=#{e.backtrace[0,10]}"
          client.emit_failure t('manage.error_installing_plugin', :name => plugin_name, :error => e)
        end
      end
    end
  end
end
