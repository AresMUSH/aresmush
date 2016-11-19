module AresMUSH
  module FS3Combat
    class CombatTargetCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      include NotAllowedWhileTurnInProgress
      
      attr_accessor :team, :targets
      
      def crack!
        cmd.crack_args!(CommonCracks.arg1_equals_arg2)
        self.team = trim_input(cmd.args.arg1).to_i
        self.targets = cmd.args.arg2 ? cmd.args.arg2.split(" ").map { |n| trim_input(n).to_i } : []
      end

      def required_args
        {
          args: [ self.targets, self.team ],
          help: 'combat'
        }
      end

      def check_team
        return t('fs3combat.invalid_team') if self.team < 1 || self.team > 5
        return t('fs3combat.invalid_team') if self.targets.empty?
        self.targets.each do |t|
          return t('fs3combat.invalid_team') if t < 1 || t > 5
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

        combat.emit_to_organizer t('fs3combat.team_target_set', :team => self.team, :targets => self.targets.join(", "))
      end
    end
  end
end