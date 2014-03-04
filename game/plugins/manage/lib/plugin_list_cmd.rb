module AresMUSH
  module Manage
    class PluginListCmd
      include AresMUSH::Plugin

      # Validators
      must_be_logged_in
      no_args
      
      def want_command?(client, cmd)
        cmd.root_is?("plugin") && cmd.switch.nil?
      end

      # TODO - validate permissions
      
      def handle
        client.emit Global.plugin_manager.plugins
      end
    end
  end
end
