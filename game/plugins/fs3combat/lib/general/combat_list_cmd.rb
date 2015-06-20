module AresMUSH
  module FS3Combat
    class CombatListCmd
      include Plugin
      include PluginRequiresLogin
      
      def want_command?(client, cmd)
        cmd.root_is?("combats")
      end
      
      def handle
        list = FS3Combat.combats.map { |c| format_combat(c)}
        client.emit BorderedDisplay.subtitled_list list, t('fs3combat.active_combats'), t('fs3combat.active_combats_titlebar')
      end
      
      def format_combat(combat)
        combatants = combat.combatants.map { |c| c.name }.join(" ")
        num = combat.num.to_s
        "#{num.ljust(3)} #{combat.organizer.name.ljust(15)} #{combatants}"
      end
    end
  end
end