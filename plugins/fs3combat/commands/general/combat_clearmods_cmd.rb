module AresMUSH
  module FS3Combat
    class CombatClearModsCmd
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

          combatant.update(spell_mod: 0)
          combatant.update(defense_mod: 0)
          combatant.update(damage_lethality_mod: 0)
          combatant.update(attack_mod: 0)


          client.emit_success t('fs3combat.mods_cleared', :name => self.name)
        end
      end
    end
  end
end
