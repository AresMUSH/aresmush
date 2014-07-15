module AresMUSH
  module Manage
    class PluginListCmd
      include Plugin
      include PluginRequiresLogin
      include PluginWithoutArgs
      
      def want_command?(client, cmd)
        cmd.root_is?("plugins")
      end
      
      def check_can_manage
        return t('dispatcher.not_allowed') if !Manage.can_manage?(client.char)
        return nil
      end

      def handle
        list = Global.plugin_manager.plugins.map { |p| p.class.name.rest("AresMUSH::") }
        client.emit BorderedDisplay.table(list, 25, t('manage.plugins'))
      end
    end
  end
end
