module AresMUSH
  module FS3Combat
    class CombatTeamCmd
      include CommandHandler
      include NotAllowedWhileTurnInProgress
      
      attr_accessor :names, :team
      
      def parse_args
        if (cmd.args =~ /=/)
          args = cmd.parse_args(ArgParser.arg1_equals_arg2)
          self.names = split_and_titlecase_arg(args.arg1)
          self.team = trim_arg(args.arg2).to_i
        else
          self.names = [enactor.name]
          self.team = trim_arg(cmd.args).to_i
        end
      end

      def required_args
        {
          args: [ self.names, self.team ],
          help: 'combat'
        }
      end

      def check_team
        return t('fs3combat.invalid_team') if self.team < 1 || self.team > 5
        return nil
      end
      
      def handle
        self.names.each do |name|
          FS3Combat.with_a_combatant(name, client, enactor) do |combat, combatant|        
            combatant.update(team: team)
            message = t('fs3combat.team_set', :name => name, :team => self.team)
            combat.emit message, FS3Combat.npcmaster_text(name, enactor)
          end
        end
      end
    end
  end
end