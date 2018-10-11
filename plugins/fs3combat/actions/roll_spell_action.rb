module AresMUSH
  module FS3Combat
    class RollSpellAction < CombatAction

attr_accessor  :spell, :args, :action

      def prepare
        target = self.action_args
      end

      def print_action
        msg = t('custom.spell_action_msg_long', :name => self.name)
      end

      def print_action_short
        t('custom.spell_action_msg_short', :spell => "Create Bloom", :target => target)
      end

      def resolve
        succeeds = Custom.roll_combat_spell_success(self.combatant, "Create Bloom")
        [t('custom.spell_resolution_msg', :name => self.name, :spell => "Create Bloom", :target => print_target_names, :succeeds => succeeds)]
      end
    end
  end
end
