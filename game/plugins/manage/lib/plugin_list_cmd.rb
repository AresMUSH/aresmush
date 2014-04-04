module AresMUSH
  module Manage
    class PluginListCmd
      include Plugin
      include PluginRequiresLogin
      include PluginWithoutArgs
      
      def want_command?(client, cmd)
        cmd.root_is?("plugins")
      end

      # TODO - check permissions
      
      def handle
        list = Global.plugin_manager.plugins.map { |p| p.class.name.rest("AresMUSH::") }
        client.emit BorderedDisplay.table(list, 25, t('manage.plugins'))
      end
    end
  end
end
