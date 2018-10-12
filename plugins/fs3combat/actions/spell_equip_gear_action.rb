module AresMUSH
  module FS3Combat
    class SpellEquipGearAction < CombatAction

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
          weapon = Global.read_config("spells", self.spell, "weapon")
          weapon_specials_str = Global.read_config("spells", self.spell, "weapon_specials")
          armor = Global.read_config("spells", self.spell, "armor")
          armor_specials_str = Global.read_config("spells", self.spell, "armor_specials")
          targets.each do |target|
            if weapon
              FS3Combat.set_weapon(combatant, target, weapon)
              if armor

              else
                messages.concat [t('custom.casts_spell', :name => self.name, :spell => self.spell, :succeeds => succeeds)]
              end
            end

            if weapon_specials_str
              weapon_specials = weapon_specials_str ? weapon_specials_str.split('+') : nil
              FS3Combat.set_weapon(combatant, target, target.weapon, weapon_specials)
              messages.concat [t('custom.casts_spell', :name => self.name, :spell => self.spell, :succeeds => succeeds)]
            end

            if armor
              FS3Combat.set_armor(combatant, target, armor)
              messages.concat [t('custom.casts_spell', :name => self.name, :spell => self.spell, :succeeds => succeeds)]
            end

            if armor_specials_str
              armor_specials = armor_specials_str ? armor_specials_str.split('+') : nil
              FS3Combat.set_armor(combatant, target, target.armor, armor_specials)
              messages.concat [t('custom.casts_spell', :name => self.name, :spell => self.spell, :succeeds => succeeds)]
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
