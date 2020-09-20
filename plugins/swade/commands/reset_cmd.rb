module AresMUSH    
  module Swade
    class ResetCmd
      include CommandHandler  
      
      # def check_chargen_locked
        # return nil if Cortex.can_manage_abilities?(enactor)
        # Chargen.check_chargen_locked(enactor)
      # end
      
      def handle
        enactor.delete_swade_chargen
        client.emit_success t('swade.reset_chargen')
      end
    end
  end
end