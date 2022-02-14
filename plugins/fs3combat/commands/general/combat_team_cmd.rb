module AresMUSH
  module FS3Combat
    class CombatTeamCmd
      include CommandHandler
      include NotAllowedWhileTurnInProgress
      
      attr_accessor :names, :team
      
      def parse_args
        if (cmd.args =~ /=/)
          args = cmd.parse_args(ArgParser.arg1_equals_arg2)
          self.names = titlecase_list_arg(args.arg1)
          self.team = trim_arg(args.arg2).to_i
        else
          self.names = [enactor.name]
          self.team = trim_arg(cmd.args).to_i
        end
      end

      def required_args
        [ self.names, self.team ]
      end

      def check_team
        return t('fs3combat.invalid_team') if self.team < 1 || self.team > 9
        return nil
      end
      
      def handle
        self.names.each do |name|
          FS3Combat.with_a_combatant(name, client, enactor) do |combat, combatant|        
            FS3Combat.change_team(combat, combatant, enactor, self.team)
          end
        end
      end
    end
  end
end