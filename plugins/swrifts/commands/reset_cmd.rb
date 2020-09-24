module AresMUSH    
  module Swrifts
    class ResetCmd
      include CommandHandler  
      
      # def check_chargen_locked
        # return nil if Cortex.can_manage_abilities?(enactor)
        # Chargen.check_chargen_locked(enactor)
      # end
      
      def handle
        enactor.delete_swrifts_chargen
        client.emit_success t('swrifts.reset_chargen')
      end
    end
  end
end