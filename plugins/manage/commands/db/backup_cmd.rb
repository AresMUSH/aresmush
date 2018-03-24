module AresMUSH
  module Manage
    class BackupCmd
      include CommandHandler
      
      def check_can_manage
        return t('dispatcher.not_allowed') if !Manage.can_manage_game?(enactor)
        return nil
      end
      
      def handle
        Manage.perform_backup(client)
      end
    end
  end
end
