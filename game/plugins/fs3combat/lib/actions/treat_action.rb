module AresMUSH
  module FS3Combat
    class TreatAction < CombatAction
      include ActionOnlyAllowsSingleTarget
      
      def parse_args(args)
        parse_targets args
      end

      def check_npc
        return t('fs3combat.can_only_treat_characters') if self.targets[0].is_npc?
        return t('fs3combat.only_pcs_can_treat') if self.combatant.is_npc?
        return nil        
      end
      
      def print_action
        msg = t('fs3combat.treat_action_msg_long', :name => self.name, :target => print_target_names)
      end
      
      def print_action_short
        t('fs3combat.treat_action_msg_short', :name => self.name, :target => print_target_names)
      end
      
      def resolve        
        [FS3Combat.treat(self.combatant.character, self.targets[0].character)]
      end
    end
  end
end