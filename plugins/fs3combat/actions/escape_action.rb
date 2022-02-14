module AresMUSH
  module FS3Combat
    class EscapeAction < CombatAction
      
      def prepare
        return t('fs3combat.not_subdued') if !self.combatant.is_subdued?
        return nil
      end

      def print_action
        t('fs3combat.escape_action_msg_long', :name => self.name, :target => self.subduer_name)
      end
      
      def print_action_short
        t('fs3combat.escape_action_msg_short', :target => self.subduer_name)
      end
      
      def subduer_name
        self.combatant.subdued_by ? self.combatant.subdued_by.name : ""
      end
      
      def subduer
        self.combatant.subdued_by
      end
      
      def reset_subdue
        self.combatant.update(subdued_by: nil)
        self.combatant.update(action_klass: nil)
        self.combatant.update(action_args: nil)
      end
      
      def resolve
        messages = []
        
        # If the subduer is no longer subduing, you succeed automatically
        if (!self.combatant.is_subdued?)
          reset_subdue
          messages << t('fs3combat.escape_action_success', :name => self.name, :target => self.subduer_name)
        else  
          # This is a little different because it forces the attacker to make another subdue roll.  This
          # ensures that we use the attacker's melee weapon skill and not the defender's weapon
          margin = FS3Combat.determine_attack_margin(self.subduer, self.combatant)
          if (margin[:hit])
            messages << t('fs3combat.escape_action_failed', :name => self.name, :target => self.subduer_name)
          else
            messages << t('fs3combat.escape_action_success', :name => self.name, :target => self.subduer_name)
            self.reset_subdue
          end
        end
        
        messages
      end
    end
  end
end