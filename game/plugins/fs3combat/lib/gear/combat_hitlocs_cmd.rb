module AresMUSH
  module FS3Combat
    class CombatHitlocsCmd
      include CommandHandler
      
      attr_accessor :name
      
      def parse_args
        self.name = cmd.args ? titlecase_arg(cmd.args) : enactor.name
      end

      def handle
        FS3Combat.with_a_combatant(self.name, client, enactor) do |combat, combatant|
          hitlocs = FS3Combat.hitloc_areas(combatant).keys
          
          template = BorderedListTemplate.new hitlocs.sort, t('fs3combat.hitlocs_for', :name => self.name)
          client.emit template.render
        end
      end
    end
  end
end