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



        weapon_type = FS3Combat.weapon_stat(self.combatant.weapon, "weapon_type")
        return t('fs3combat.subdue_uses_melee') if weapon_type != "Melee"


        error = self.parse_targets(self.names)
        return error if error

        return t('fs3combat.only_one_target') if (self.targets.count > 1)

        return nil
      end

      def print_action
        t('fs3combat.stun_action_msg_long', :name => self.name, :target => print_target_names)
      end

      def print_action_short
        t('fs3combat.stun_action_msg_short', :target => print_target_names)
      end

      def resolve
        messages = []

        targets.each do |target|

          margin = FS3Combat.determine_attack_margin(self.combatant, target)
          if (margin[:hit])
            target.update(subdued_by: self.combatant)
            target.update(magic_stun: true)
            rounds = Global.read_config("spells", self.spell, "rounds")

            #Rounds + 1, otherwise the newturn it casts in will count as a round.
            target.update(magic_stun_counter: rounds.to_i + 1)
            target.update(magic_stun_spell: spell)
            target.update(action_klass: nil)
            target.update(action_args: nil)
            messages << t('fs3combat.stun_action_success', :name => self.name, :target => print_target_names)
          else
            messages << t('fs3combat.stun_action_failed', :name => self.name, :target => print_target_names)
          end
        end

        messages
      end
    end
  end
end
