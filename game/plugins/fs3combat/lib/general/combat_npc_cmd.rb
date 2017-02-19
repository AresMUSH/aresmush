module AresMUSH
  module FS3Combat
    class CombatNpcCmd
      include CommandHandler
      include NotAllowedWhileTurnInProgress
      
      attr_accessor :level, :name
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.name = titlecase_arg(args.arg1)
        self.level = titlecase_arg(args.arg2)
      end

      def required_args
        {
          args: [ self.level ],
          help: 'combat org'
        }
      end
      
      def check_reason
        levels = FS3Combat.npc_type_names
        return t('fs3combat.invalid_npc_level', :levels => levels.join(", ")) if !levels.include?(self.level)
        return nil
      end
      
      def handle
        FS3Combat.with_a_combatant(self.name, client, enactor) do |combat, combatant|
          
          if (combat.organizer != enactor)
            client.emit_failure t('fs3combat.only_organizer_can_do')
            return
          end
          
          if (!combatant.is_npc?)
            client.emit_failure t('fs3combat.not_a_npc')
            return
          end

          combatant.npc.update(level: self.level)
          client.emit_success t('fs3combat.npc_skill_set', :name => self.name, :level => self.level)
        end
      end
    end
  end
end