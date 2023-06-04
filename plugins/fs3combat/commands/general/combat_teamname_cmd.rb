module AresMUSH
  module FS3Combat
    class CombatTeamnameCmd
      include CommandHandler
      include NotAllowedWhileTurnInProgress
      
      attr_accessor :team, :name
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_optional_arg2)
        self.team = integer_arg(args.arg1)
        self.name = trim_arg(args.arg2)
      end

      def required_args
        [ self.team ]
      end

      def check_team
        return t('fs3combat.invalid_team') if self.team < 1 || self.team > 9
        return nil
      end
      
      def handle
        if (!enactor.is_in_combat?)
          client.emit_failure t('fs3combat.you_are_not_in_combat')
          return
        end
                
        combat = enactor.combat
        team_names = combat.team_names || {}
        if (self.team.blank?)
          team_names.delete "#{self.team}"
        else          
          team_names["#{self.team}"] = self.name
        end
        
        combat.update(team_names: team_names)

        FS3Combat.emit_to_combat combat, t('fs3combat.team_name_set', :enactor => enactor_name, :team => self.team, :name => self.name || self.team)
      end
    end
  end
end