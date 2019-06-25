module AresMUSH
  module FS3Combat
    class SpellStunAction < CombatAction
      attr_accessor  :spell, :target, :names
      def prepare
        if (self.action_args =~ /\//)
          self.names = self.action_args.before("/")
          self.spell = self.action_args.after("/")
        else
          self.names = self.name
          self.spell = self.action_args
        end


        rounds = Global.read_config("spells", self.spell, "rounds")
        weapon_type = FS3Combat.weapon_stat(self.combatant.weapon, "weapon_type")
        return t('fs3combat.subdue_uses_melee') if weapon_type != "Melee"


        error = self.parse_targets(self.names)
        return error if error

        return t('fs3combat.only_one_target') if (self.targets.count > 1)

        return nil
      end

      def print_action
        msg = t('custom.spell_target_action_msg_long', :name => self.name, :spell => self.spell, :targets => print_target_names)
        msg
      end

      def print_action_short
        t('custom.spell_target_action_msg_short', :targets => print_target_names)
      end

      def resolve
        messages = []

        targets.each do |target|

          margin = FS3Combat.determine_attack_margin(self.combatant, target)
          if (margin[:hit])
            target.update(subdued_by: self.combatant)
            target.update(magic_stun: true)
            rounds = Global.read_config("spells", self.spell, "rounds")

            target.update(magic_stun_counter: rounds.to_i)
            target.update(magic_stun_spell: spell)
            target.update(action_klass: nil)
            target.update(action_args: nil)
            messages << t('custom.spell_resolution_msg', :name => self.name, :spell => self.spell, :succeeds => "%xgSUCCEEDS%xn")
          else
            messages << t('custom.spell_target_resolution_msg', :name => self.name, :spell => spell, :targets => print_target_names, :succeeds => "%xrFAILS%xn")
          end
        end
        messages
      end
    end
  end
end
