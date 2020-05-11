module AresMUSH
  module FS3Combat
    class RallyAction < CombatAction
      
      def prepare
        error = self.parse_targets( self.action_args)
        return error if error
        
        return t('fs3combat.only_one_target') if (self.targets.count > 1)
        
        if (!self.target.is_ko)
          return t('fs3combat.target_not_koed')
        end
        
        return nil
      end
      
      def print_action
        msg = t('fs3combat.rally_action_msg_long', :name => self.name, :target => print_target_names)
      end
      
      def print_action_short
        t('fs3combat.rally_action_msg_short', :name => self.name, :target => print_target_names)
      end
      
      def resolve
        FS3Combat.check_for_unko(self.target)
        if (self.target.is_ko)
          message = t('fs3combat.rally_resolution_failed', :target => print_target_names, :name => self.name)
          if (!self.combatant.is_npc?)
            Achievements.award_achievement(self.combatant.associated_model, "fs3_rallied")  
          end
        else
          message = t('fs3combat.rally_resolution_success', :target => print_target_names, :name => self.name)
        end
        
        [ message ]
      end
    end
  end
end