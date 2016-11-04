module AresMUSH
  module FS3Combat
    class CombatTeamCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      include NotAllowedWhileTurnInProgress
      
      attr_accessor :names, :team
      
      def crack!
        if (cmd.args =~ /=/)
          cmd.crack_args!(CommonCracks.arg1_equals_arg2)
          self.names = cmd.args.arg1 ? cmd.args.arg1.split(" ").map { |n| titleize_input(n) } : nil
          self.team = trim_input(cmd.args.arg2).to_i
        else
          self.names = [enactor.name]
          self.team = trim_input(cmd.args).to_i
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