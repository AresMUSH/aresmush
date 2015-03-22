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
        client.emit BorderedDisplay.list list, t('fs3combat.active_combats')
      end
      
      def format_combat(combat, index)
        number = (index + 1).to_s
        "#{number.ljust(3)} #{combat.organizer.name}"
      end
    end
  end
end