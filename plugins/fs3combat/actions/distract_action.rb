module AresMUSH
  module FS3Combat
    class DistractAction < CombatAction      
      def prepare
        error = self.parse_targets(self.action_args)
        return error if error

        weapon_type = FS3Combat.weapon_stat(self.combatant.weapon, "weapon_type")
        return t('fs3combat.use_explode_command') if weapon_type == "Explosive"
        return t('fs3combat.use_suppress_command') if weapon_type == "Suppressive"
        return t('fs3combat.too_many_targets') if (self.targets.count > 1)
        return nil
      end
      
      def print_action
        t('fs3combat.distract_action_msg_long', :name => self.name, :targets => print_target_names)
      end
      
      def print_action_short
        t('fs3combat.distract_action_msg_short', :targets => print_target_names)
      end
      
      def resolve
        messages = []
        
        composure = Global.read_config("fs3combat", "composure_skill")
        attack_roll = FS3Combat.roll_attack(self.combatant, target)
        defense_roll = target.roll_ability(composure)
        margin = attack_roll - defense_roll
        
        self.combatant.log "#{self.name} distracting #{target.name}.  atk=#{attack_roll} def=#{defense_roll}"
        if (margin >= 1)
          target.update(action_klass: nil)
          target.update(action_args: nil)
          messages << t('fs3combat.distract_successful_msg', :name => self.name, 
             :target => target.name, :weapon => self.combatant.weapon)
           if (!self.combatant.is_npc?)
             Achievements.award_achievement(self.combatant.associated_model, "fs3_distracted")  
           end
        else
          messages << t('fs3combat.distract_failed_msg', :name => self.name, 
             :target => target.name, :weapon => self.combatant.weapon)
        end

        messages
      end
    end
  end
end