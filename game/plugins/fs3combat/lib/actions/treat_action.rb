module AresMUSH
  module FS3Combat
    class TreatAction < CombatAction
      
      def prepare
        error = self.parse_targets( self.action_args)
        return error if error
        
        return t('fs3combat.only_one_target') if (self.targets.count > 1)
        return nil
      end
      
      def print_action
        msg = t('fs3combat.treat_action_msg_long', :name => self.name, :target => print_target_names)
      end
      
      def print_action_short
        t('fs3combat.treat_action_msg_short', :name => self.name, :target => print_target_names)
      end
      
      def resolve        
        [FS3Combat.treat(self.targets[0].associated_model, self.combatant.associated_model)]
      end
    end
  end
end