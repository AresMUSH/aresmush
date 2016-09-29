module AresMUSH
  module FS3Combat
    class CombatHitlocsCmd
      include CommandHandler
      include CommandRequiresLogin
      
      attr_accessor :name
      
      def crack!
        self.name = cmd.args ? titleize_input(cmd.args) : enactor.name
      end

      def handle
        FS3Combat.with_a_combatant(self.name, client) do |combat, combatant|
          hitlocs = combatant.hitloc_chart.uniq
          client.emit BorderedDisplay.list hitlocs.sort, t('fs3combat.hitlocs_for', :name => self.name)
        end
      end
    end
  end
end