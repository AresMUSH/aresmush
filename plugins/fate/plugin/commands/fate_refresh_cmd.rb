module AresMUSH    
  module Fate
    class FateRefreshCmd
      include CommandHandler
      
      
      def check_is_allowed
        return nil if Fate.can_manage_abilities?(enactor)
        t('dispatcher.not_allowed')
      end
      
      def handle
        Fate.refresh_fate
        client.emit_success t('fate.fate_refreshed')
      end
    end
  end
end