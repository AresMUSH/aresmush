module AresMUSH
  module Manage
    class PluginListCmd
      include CommandHandler
      
      def check_can_manage
        return t('dispatcher.not_allowed') if !Manage.can_manage_game?(enactor)
        return nil
      end

      def handle
        list = Global.plugin_manager.plugins.map { |p| p.name.rest("AresMUSH::") }.sort
        client.emit BorderedDisplay.table(list, 25, t('manage.plugins'))
      end
    end
  end
end
