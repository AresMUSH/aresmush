module AresMUSH
  module Manage
    class DbSaveCmd
      include CommandHandler
      
      def check_can_manage
        return t('dispatcher.not_allowed') if !Manage.can_manage_game?(enactor)
        return nil
      end
      
      def handle
        Manage.save_db
        client.emit_success t('manage.db_save_triggered')
      end
    end
  end
end
