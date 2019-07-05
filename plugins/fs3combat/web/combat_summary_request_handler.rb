module AresMUSH
  module FS3Combat
    class CombatSummaryRequestHandler
      def handle(request)
        id = request.args[:id]
        enactor = request.enactor
        
        error = Website.check_login(request, true)
        return error if error
        
        combat = Combat[id]
        if (!combat)
          return { error: t('fs3combat.invalid_combat_number') }
        end
        
        FS3Combat.build_combat_web_data(combat, enactor)
      end
    end
  end
end


