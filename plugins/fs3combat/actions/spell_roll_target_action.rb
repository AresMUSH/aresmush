module AresMUSH
  module FS3Combat
    class RollSpellTargetAction < CombatAction

attr_accessor  :spell, :args, :action, :target, :names

      def prepare

        if (self.action_args =~ /\//)
          self.names = self.action_args.before("/")
          self.spell = self.action_args.after("/")
        else
          self.names = self.name
          self.spell = self.action_args
        end

        error = self.parse_targets(self.names)
        return error if error

        return t('fs3combat.only_one_target') if (self.targets.count > 1)

        # return nil
      end

      def print_action
        msg = self.action_args
        # msg = t('custom.roll_spell_target_action_msg_long', :name => self.name, :spell => self.spell, :target => print_target_names)
        msg
      end

      def print_action_short
        t('custom.spell_action_msg_short')
      end

      def resolve
        succeeds = Custom.roll_combat_spell_success(self.combatant, self.spell)
        [t('custom.roll_spell_target_resolution_msg', :name => self.name, :spell => self.spell, :target => print_target_names, :succeeds => succeeds)]
      end
    end
  end
end
