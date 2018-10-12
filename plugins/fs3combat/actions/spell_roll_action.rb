module AresMUSH
  module FS3Combat
    class RollSpellAction < CombatAction

attr_accessor  :spell, :args, :action, :target, :names

      def prepare
        self.spell = self.action_args
        return nil

      end

      def print_action
        msg = t('custom.roll_spell_action_msg_long', :name => self.name, :spell => self.spell)
        msg
      end

      def print_action_short
        t('custom.spell_action_msg_short')
      end

      def resolve
        succeeds = Custom.roll_combat_spell_success(self.combatant, self.spell)
        [t('custom.roll_spell_resolution_msg', :name => self.name, :spell => self.spell, :succeeds => succeeds)]
      end
    end
  end
end
