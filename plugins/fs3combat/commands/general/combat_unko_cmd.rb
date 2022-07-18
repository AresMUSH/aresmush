module AresMUSH
  module FS3Combat
    class CombatUnkoCmd
      include CommandHandler
      include NotAllowedWhileTurnInProgress
      
      attr_accessor :name
      
      def parse_args
        self.name = titlecase_arg(cmd.args)
      end

      def required_args
        [ self.name ]
      end
      
      def handle
        FS3Combat.with_a_combatant(self.name, client, enactor) do |combat, combatant|
          
          if (combat.organizer != enactor)
            client.emit_failure t('fs3combat.only_organizer_can_do')
            return
          end

          combatant.update(is_ko: false)
          FS3Combat.emit_to_combat combatant.combat, t('fs3combat.is_no_longer_koed', :name => combatant.name), nil, true
        end
      end
    end
  end
end