module AresMUSH
  module Manage
    class UnloadPluginCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
      
      attr_accessor :load_target

      def initialize
        self.required_args = ['load_target']
        self.help_topic = 'unload'
        super
      end
      
      def crack!
        self.load_target = cmd.args
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("unload")
      end

      # TODO - check permissions
      
      def handle
        begin
          Global.plugin_manager.unload_plugin(load_target)
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
