module AresMUSH
  module Manage
    class PluginListCmd
      include CommandHandler
      
      def check_can_manage
        return t('dispatcher.not_allowed') if !Manage.can_manage_game?(enactor)
        return nil
      end

      def handle
        list = Manage.list_plugins_with_versions
        template = BorderedTableTemplate.new list, 25, t('manage.plugins')
        client.emit template.render
      end
    end
  end
end
