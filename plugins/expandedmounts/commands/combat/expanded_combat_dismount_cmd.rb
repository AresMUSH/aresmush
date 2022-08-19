module AresMUSH
  module ExpandedMounts
    class ExpandedCombatDismountCmd
      include CommandHandler
      #include NotAllowedWhileTurnInProgress
      
      attr_accessor :name

      def parse_args
        if (cmd.args)
          self.name = titlecase_arg(cmd.args)
        else
          self.name = enactor_name
        end
      end

      def required_args
        [ self.name ]
      end

      def check_errors
        return t('fs3combat.invalid_combatant_name') if Mount.named(self.name)
      end
      
      def handle
        FS3Combat.with_a_combatant(self.name, client, enactor) do |combat, combatant|   
          if (!combatant.is_on_mount?)
            client.emit_failure t('expandedmounts.not_on_mount', :name => self.name)
            return
          end
          ExpandedMounts.leave_mount(combatant)
        end
      end
    end
  end
end