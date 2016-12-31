module AresMUSH
  module FS3Combat
    class CombatLogCmd
      include CommandHandler
      
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
        
        if (combat.debug_log)
          list = combat.debug_log.combat_log_messages.sort_by(:timestamp).map { |l| "#{l.timestamp} #{l.created_at} #{l.message}"}
        else
          list = []
        end
        client.emit BorderedDisplay.paged_list(list, self.page, 25, t('fs3combat.log_title'))
      end
    end
  end
end