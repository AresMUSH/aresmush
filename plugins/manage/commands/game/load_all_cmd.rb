module AresMUSH
  module Manage
    class LoadAllCmd
      include CommandHandler
      
      def check_can_manage
        return t('dispatcher.not_allowed') if !Manage.can_manage_game?(enactor)
        return nil
      end
      
      def handle
        client.emit_ooc t('manage.load_all')
        error = Manage.load_all
        if (error)
          client.emit_failure error
        else
          client.emit_success t('manage.load_all_complete')
        end
      end
    end
  end
end
