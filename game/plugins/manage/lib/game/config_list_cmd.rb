module AresMUSH
  module Manage
    class ConfigListCmd
      include CommandHandler
      include CommandRequiresLogin
      
      def check_can_manage
        return t('dispatcher.not_allowed') if !Manage.can_manage_game?(client.char)
        return nil
      end
      
      def handle
        client.emit BorderedDisplay.table(Global.config_reader.config.keys.sort, 25, t('manage.config_sections'))
      end
    end
  end
end