module AresMUSH
  module FS3Combat
    class SpellModAction < CombatAction

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
          lethal_mod = Global.read_config("spells", self.spell, "lethal_mod")
          attack_mod = Global.read_config("spells", self.spell, "attack_mod")
          defense_mod = Global.read_config("spells", self.spell, "defense_mod")
          spell_mod = Global.read_config("spells", self.spell, "spell_mod")
          targets.each do |target|
            if lethal_mod
              current_mod = target.damage_lethality_mod
              new_mod = current_mod + lethal_mod
              target.update(damage_lethality_mod: new_mod)
              messages.concat [t('custom.cast_mod', :name => self.name, :spell => self.spell, :succeeds => succeeds, :target =>  print_target_names, :mod => lethal_mod, :type => "lethality", :total_mod => target.damage_lethality_mod)]
            end

            if attack_mod
              current_mod = target.attack_mod
              new_mod = current_mod + attack_mod
              target.update(attack_mod: new_mod)
              messages.concat [t('custom.cast_mod', :name => self.name, :spell => self.spell, :succeeds => succeeds, :target =>  print_target_names, :mod => attack_mod, :type => "attack", :total_mod => target.attack_mod)]
            end

            if defense_mod
              current_mod = target.defense_mod
              new_mod = current_mod + defense_mod
              target.update(defense_mod: new_mod)
              messages.concat [t('custom.cast_mod', :name => self.name, :spell => self.spell, :succeeds => succeeds, :target =>  print_target_names, :mod => defense_mod, :type => "defense", :total_mod => target.defense_mod)]
            end

            if spell_mod
              current_mod = target.spell_mod
              new_mod = current_mod + spell_mod
              target.update(spell_mod: new_mod)
              messages.concat [t('custom.cast_mod', :name => self.name, :spell => self.spell, :succeeds => succeeds, :target =>  print_target_names, :mod => spell_mod, :type => "spell", :total_mod => target.spell_mod)]
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
