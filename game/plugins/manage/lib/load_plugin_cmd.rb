module AresMUSH
  module Manage
    class LoadPluginCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
      
      attr_accessor :load_target
      
      def initialize
        self.required_args = ['load_target']
        self.help_topic = 'load'
        super
      end
      
      def crack!
        self.load_target = cmd.args
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("load") && 
        cmd.args != "locale" && cmd.args != "config"
      end

      # TODO - check permissions
      
      def handle
        begin
          begin
            Global.plugin_manager.unload_plugin(load_target)
          rescue SystemNotFoundException
            # Swallow this error.  Just means you're loading a plugin for the very first time.
          end
          Global.plugin_manager.load_plugin(load_target)
          Global.locale.load!
          Global.config_reader.read
          client.emit_success t('manage.plugin_loaded', :name => load_target)
        rescue SystemNotFoundException => e
          client.emit_failure t('manage.plugin_not_found', :name => load_target)
        rescue Exception => e
          client.emit_failure t('manage.error_loading_plugin', :name => load_target, :error => e.to_s)
        end
      end
    end
  end
end
