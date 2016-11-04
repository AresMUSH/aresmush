module AresMUSH
  module FS3Combat
    class CombatLogCmd
      include CommandHandler
      include CommandRequiresLogin
      
      attr_accessor :page
         
      def crack!
        self.page = cmd.args ? cmd.args.to_i : 1
      end
      
      def handle
        combat = FS3Combat.combat(enactor.name)
        if (!combat)
          client.emit_failure t('fs3combat.you_are_not_in_combat')
          return
        end
        
        list = combat.debug_log ? combat.debug_log.combat_log_messages.map { |l| "#{l.created_at} #{l.message}"} : []
        client.emit BorderedDisplay.paged_list(list, self.page, 25, t('fs3combat.log_title'))
      end
    end
  end
end