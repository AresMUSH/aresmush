module AresMUSH
  module FS3Combat
    class TreatAction < CombatAction
      
      def prepare
        error = self.parse_targets( self.action_args)
        return error if error
        
        return t('fs3combat.only_one_target') if (self.targets.count > 1)
                
        wound = FS3Combat.worst_treatable_wound(self.target.associated_model)
        if (!wound)
          return t('fs3combat.target_has_no_treatable_wounds', :name => self.target.name)
        end                
        
        if (self.target != self.combatant && !self.target.is_passing?)
          return t('fs3combat.patient_must_pass')
        end
        
        return nil
      end
      
      def print_action
        msg = t('fs3combat.treat_action_msg_long', :name => self.name, :target => print_target_names)
      end
      
      def print_action_short
        t('fs3combat.treat_action_msg_short', :name => self.name, :target => print_target_names)
      end
      
      def resolve
        message = FS3Combat.treat(self.target.associated_model, self.combatant.associated_model)
        FS3Combat.check_for_unko(self.target)
        if (!self.combatant.is_npc?)
          Achievements.award_achievement(self.combatant.associated_model, "fs3_treated")  
        end
        [message]
      end
    end
  end
end