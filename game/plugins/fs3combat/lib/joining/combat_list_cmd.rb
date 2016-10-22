module AresMUSH
  module FS3Combat
    class CombatListCmd
      include CommandHandler
      include CommandRequiresLogin
      
      def handle
        list = FS3Combat.combats.map { |c| format_combat(c)}
        client.emit BorderedDisplay.subtitled_list list, t('fs3combat.active_combats'), t('fs3combat.active_combats_titlebar')
      end
      
      def format_combat(combat)
        combatants = combat.combatants.map { |c| c.name }.join(" ")
        num = combat.id.to_s
        "#{num.ljust(3)} #{combat.organizer.name.ljust(15)} #{combatants}"
      end
    end
  end
end