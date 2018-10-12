module AresMUSH
  module FS3Combat
    class SpellResAction < CombatAction

attr_accessor  :spell, :target, :names

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


      end

      def print_action
        msg = t('custom.roll_spell_target_action_msg_long', :name => self.name, :spell => self.spell, :target => print_target_names)
        msg
      end

      def print_action_short
        t('custom.spell_action_msg_short')
      end

      def resolve
        succeeds = Custom.roll_combat_spell_success(self.combatant, self.spell)
        messages = []
        if succeeds == "%xgSUCCEEDS%xn"

          targets.each do |target|
            Custom.undead(target.associated_model)
            messages.concat [t('custom.cast_res', :name => self.name, :spell => self.spell, :succeeds => succeeds, :target => print_target_names)]
            FS3Combat.emit_to_combatant target, t('custom.been_resed', :name => self.name)
          end
        else
          messages.concat [t('custom.roll_spell_target_resolution_msg', :name => self.name, :spell => spell, :target => print_target_names, :succeeds => succeeds)]
        end
        messages
      end
    end
  end
end
