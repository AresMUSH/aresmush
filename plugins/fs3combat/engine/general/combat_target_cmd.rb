module AresMUSH
  module FS3Combat
    class CombatTargetCmd
      include CommandHandler
      include NotAllowedWhileTurnInProgress
      
      attr_accessor :team, :targets
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.team = trim_arg(args.arg1).to_i
        self.targets = args.arg2 ? args.arg2.split(/[, ]/).map { |n| trim_arg(n).to_i } : nil
      end

      def required_args
        [ self.targets, self.team ]
      end

      def check_team
        return t('fs3combat.invalid_team') if self.team < 1 || self.team > 9
        return t('fs3combat.invalid_team') if self.targets.empty?
        self.targets.each do |t|
          return t('fs3combat.invalid_team') if t < 1 || t > 9
        end
        return nil
      end
      
      def handle
        if (!enactor.is_in_combat?)
          client.emit_failure t('fs3combat.you_are_not_in_combat')
          return
        end
                
        combat = enactor.combat
        team_targets = combat.team_targets || {}
        team_targets[self.team] = self.targets
        
        combat.update(team_targets: team_targets)

        FS3Combat.emit_to_organizer combat, t('fs3combat.team_target_set', :team => self.team, :targets => self.targets.join(", "))
      end
    end
  end
end