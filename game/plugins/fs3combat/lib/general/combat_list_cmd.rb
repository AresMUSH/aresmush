module AresMUSH
  module FS3Combat
    class CombatListCmd
      include Plugin
      include PluginRequiresLogin
      
      def want_command?(client, cmd)
        cmd.root_is?("combats")
      end
      
      def handle
        list = FS3Combat.combats.each_with_index.map { |c, i| format_combat(c, i)}
        client.emit BorderedDisplay.subtitled_list list, t('fs3combat.active_combats'), t('fs3combat.active_combats_titlebar')
      end
      
      def format_combat(combat, index)
        number = (index + 1).to_s
        combatants = combat.combatants.map { |c| c.name }.join(" ")
        "#{number.ljust(3)} #{combat.organizer.name.ljust(15)} #{combatants}"
      end
    end
  end
end