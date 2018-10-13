module AresMUSH
  module Manage
    class PluginInstallCmd
      include CommandHandler
      
      attr_accessor :name
      
      def parse_args
        self.name = trim_arg(cmd.args)
      end
      
      def required_args
        [ self.name ]
      end
      
      def check_can_manage
        return t('dispatcher.not_allowed') if !Manage.can_manage_game?(enactor)
        return nil
      end
      
      def handle        
        begin
          url = "https://github.com/AresMUSH/ares-extras/tree/master/plugins/#{self.name}"
          importer = AresMUSH::Manage::PluginImporter.new(self.name)
          importer.import
          Global.plugin_manager.load_plugin(self.name)                      
          client.emit_success t('manage.plugin_installed', :name => self.name, :url => url)
        rescue Exception => e
          Global.logger.debug "Error instaling plugin: #{e}  backtrace=#{e.backtrace[0,10]}"
          client.emit_failure t('manage.error_installing_plugin', :name => self.name, :error => e)
        end
      end
    end
  end
end
