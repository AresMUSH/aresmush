module AresMUSH
  module FS3Combat
    class SpellAction < CombatAction

      def prepare
      end

      def print_action
        msg = t('custom.spell_action_msg_long', :name => self.name)
      end

      def print_action_short
        t('custom.spell_action_msg_short')
      end

      def resolve
        [t('custom.spell_resolution_msg', :name => self.name)]
      end
    end
  end
end
