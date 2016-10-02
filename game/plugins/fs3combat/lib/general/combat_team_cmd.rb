module AresMUSH
  module FS3Combat
    class CombatTeamCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      include NotAllowedWhileTurnInProgress
      
      attr_accessor :name, :team
      
      def crack!
        if (cmd.args =~ /=/)
          cmd.crack_args!(CommonCracks.arg1_equals_arg2)
          self.name = titleize_input(cmd.args.arg1)
          self.team = trim_input(cmd.args.arg2).to_i
        else
          self.name = enactor.name
          self.team = trim_input(cmd.args).to_i
        end
      end

      def required_args
        {
          args: [ self.name, self.team ],
          help: 'combat'
        }
      end

      def check_team
        return t('fs3combat.invalid_team') if self.team < 1 || self.team > 5
        return nil
      end
      
      def handle
        FS3Combat.with_a_combatant(name, client, enactor) do |combat, combatant|        
          combatant.team = team
          combatant.save
          message = t('fs3combat.team_set', :name => self.name, :team => self.team)
          combat.emit message, FS3Combat.npcmaster_text(name, enactor)
        end
      end
    end
  end
end