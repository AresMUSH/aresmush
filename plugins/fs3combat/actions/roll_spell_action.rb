module AresMUSH
  module FS3Combat
    class RollSpellAction < CombatAction

attr_accessor :caster_combat, :spell

      def prepare

      end

      def print_action
        msg = self.caster_combat
        # msg = t('custom.spell_action_msg_long', :name => self.name)
      end

      def print_action_short
        # t('custom.spell_action_msg_short')
      end

      def resolve
        ["test"]
        # succeeds = Custom.roll_combat_spell_success(self.caster_combat, self.spell)
        # [t('custom.spell_resolution_msg', :name => self.name, :spell => spell, :target => "Test")]
      end
    end
  end
end
