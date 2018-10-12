module AresMUSH
  module FS3Combat
    class SpellHealAction < CombatAction

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
          heal_points = Global.read_config("spells", self.spell, "heal_points")
          targets.each do |target|
            wound = FS3Combat.worst_treatable_wound(target.associated_model)
            if (wound)
              FS3Combat.heal(wound, heal_points)
              messages.concat [t('custom.cast_heal', :name => self.name, :spell => spell, :succeeds => succeeds, :target => print_target_names, :points => heal_points)]
            else
               messages.concat [t('custom.cast_heal_no_effect', :name => self.name, :spell => spell, :succeeds => succeeds, :target => print_target_names)]
            end
          end
        else
          messages.concat [t('custom.roll_spell_target_resolution_msg', :name => self.name, :spell => spell, :target => print_target_names, :succeeds => succeeds)]
        end
        messages
      end
    end
  end
end
