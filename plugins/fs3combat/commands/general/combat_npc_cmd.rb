module AresMUSH
  module FS3Combat
    class CombatNpcCmd
      include CommandHandler
      include NotAllowedWhileTurnInProgress
      
      attr_accessor :level, :names
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.names = list_arg(args.arg1)
        self.level = titlecase_arg(args.arg2)
      end

      def required_args
        [ self.level ]
      end
      
      def check_reason
        levels = FS3Combat.npc_type_names
        return t('fs3combat.invalid_npc_level', :levels => levels.join(", ")) if !levels.include?(self.level)
        return nil
      end
      
      def handle
        self.names.each do |name|
          FS3Combat.with_a_combatant(name, client, enactor) do |combat, combatant|
          
            if (combat.organizer != enactor)
              client.emit_failure t('fs3combat.only_organizer_can_do')
              return
            end
          
            if (!combatant.is_npc?)
              client.emit_failure t('fs3combat.not_a_npc')
              return
            end

            combatant.npc.update(level: self.level)
            client.emit_success t('fs3combat.npc_skill_set', :name => name, :level => self.level)
          end
        end
      end
    end
  end
end