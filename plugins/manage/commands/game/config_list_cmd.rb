module AresMUSH
  module Manage
    class ConfigListCmd
      include CommandHandler
      
      def check_can_manage
        return t('dispatcher.not_allowed') if !Manage.can_manage_game?(enactor)
        return nil
      end
      
      def handle
        template = BorderedTableTemplate.new Global.config_reader.config.keys.sort, 25, t('manage.config_sections')
        client.emit template.render
      end
    end
  end
end