module AresMUSH
  module FS3Combat
    class SpellAction < CombatAction
      attr_accessor  :spell, :target, :names, :target_optional, :has_target

      def prepare
        if (self.action_args =~ /\//)
          self.spell = self.action_args.before("/")
          self.names = self.action_args.after("/")
          self.has_target = true
        else
          self.names = self.name
          self.spell = self.action_args
        end
        self.spell = self.spell.titlecase

        self.target_optional = Global.read_config("spells", self.spell, "target_optional")

        error = self.parse_targets(self.names)
        return error if error

        num = Global.read_config("spells", self.spell, "target_num")
        if self.target_optional
          return t('magic.too_many_targets', :spell => self.spell, :num => num) if (self.targets.count > num)
        end
        spell_list = Global.read_config("spells")
        return t('magic.not_spell') if !spell_list.include?(self.spell)
        return t('magic.dont_know_spell') if (Magic.knows_spell?(combatant, self.spell) == false && Magic.item_spell(combatant.associated_model) != spell)

      end

      def print_action

        if self.has_target
          msg = t('magic.spell_target_action_msg_long', :name => self.name, :spell => self.spell, :target => print_target_names)
          msg
        else
          msg = t('magic.spell_action_msg_long', :name => self.name, :spell => self.spell, :target => print_target_names)
          msg
        end
      end

      def print_action_short
        t('magic.spell_target_action_msg_short', :target => print_target_names)
      end

      def resolve
        succeeds = Magic.roll_combat_spell_success(self.combatant, self.spell)
        messages = []
        if succeeds == "%xgSUCCEEDS%xn"
          weapon = Global.read_config("spells", self.spell, "weapon")
          weapon_specials_str = Global.read_config("spells", self.spell, "weapon_specials")
          armor = Global.read_config("spells", self.spell, "armor")
          armor_specials_str = Global.read_config("spells", self.spell, "armor_specials")
          heal_points = Global.read_config("spells", self.spell, "heal_points")
          is_revive = Global.read_config("spells", self.spell, "is_revive")
          is_res = Global.read_config("spells", self.spell, "is_res")
          damage_inflicted = Global.read_config("spells", self.spell, "damage_inflicted")
          damage_desc = Global.read_config("spells", spell, "damage_desc")
          lethal_mod = Global.read_config("spells", self.spell, "lethal_mod")
          attack_mod = Global.read_config("spells", self.spell, "attack_mod")
          defense_mod = Global.read_config("spells", self.spell, "defense_mod")
          spell_mod = Global.read_config("spells", self.spell, "spell_mod")
          stance = Global.read_config("spells", self.spell, "stance")
          target_optional = Global.read_config("spells", self.spell, "target_optional")
          roll = Global.read_config("spells", self.spell, "roll")
          effect = Global.read_config("spells", self.spell, "effect")
          damage_type = Global.read_config("spells", self.spell, "damage_type")
          rounds = Global.read_config("spells", self.spell, "rounds")

          targets.each do |target|
            #Attacks against shields
            if (effect == "Psionic" && target.mind_shield > 0 && Magic.roll_shield(target, combatant, self.spell) == "shield")
               messages.concat [t('magic.shield_held', :name => self.name, :spell => self.spell, :mod => "", :shield => "Mind Shield", :target => print_target_names)]


            else
              #Psionic Protection
              if self.spell == "Mind Shield"
                message = Magic.cast_mind_shield(combatant, target, self.spell, rounds)
                messages.concat message
              end

              #Fire Protection
               if self.spell == "Endure Fire"
                 message = Magic.cast_endure_fire(combatant, target, self.spell, rounds)
                 messages.concat message
               end

              #Cold Protection
              if self.spell == "Endure Cold"
                message = Magic.cast_endure_cold(combatant, target, self.spell, rounds)
                messages.concat message
              end

              #Healing
              if heal_points
                message = Magic.cast_combat_heal(combatant, target, self.spell, rounds)
                messages.concat message
              end

              #Equip Weapon
              if (weapon && weapon != "Spell")
                FS3Combat.set_weapon(combatant, target, weapon)
                if armor

                else
                  messages.concat [t('magic.casts_spell', :name => self.name, :spell => self.spell, :mod => "", :succeeds => succeeds)]
                end
              end

              #Equip Weapon Specials
              if weapon_specials_str
                Magic.spell_weapon_effects(self.combatant, self.spell)
                weapon = self.combatant.weapon.before("+")
                FS3Combat.set_weapon(nil, target, weapon, [weapon_specials_str])

                if heal_points

                elsif lethal_mod || defense_mod || attack_mod || spell_mod

                else
                  messages.concat [t('magic.casts_spell', :name => self.name, :spell => self.spell, :mod => "", :succeeds => succeeds)]
                end
              end

              #Equip Armor
              if armor
                FS3Combat.set_armor(combatant, target, armor)
                messages.concat [t('magic.casts_spell', :name => self.name, :spell => self.spell, :mod => "", :succeeds => succeeds)]
              end

              #Equip Armor Specials
              if armor_specials_str
                message = Magic.cast_armor_specials(combatant, target, self.spell, rounds)
                messages.concat message
              end

              #Reviving
              if is_revive
                message = Magic.cast_revive(combatant, target, self.spell)
                messages.concat message
              end

              #Ressurrection
              if is_res
                message = Magic.cast_resurrection(combatant, target, self.spell)
                messages.concat message
              end

              #Inflict Damage
              if damage_inflicted
                message = Magic.cast_inflict_damage(combatant, target, self.spell, damage_inflicted, damage_desc)
                messages.concat message
              end

              #Apply Mods
              if lethal_mod
                message = Magic.cast_lethal_mod(combatant, target, spell, rounds, lethal_mod)
                messages.concat message
              end

              if attack_mod
                message = Magic.cast_attack_mod(combatant, target, spell, rounds, attack_mod)
                messages.concat message
              end

              if defense_mod
                message = Magic.cast_defense_mod(combatant, target, spell, rounds, defense_mod)
                messages.concat message
              end

              if spell_mod
                message = Magic.cast_spell_mod(combatant, target, spell, rounds, spell_mod)
                messages.concat message
              end

              #Change Stance
              if stance
                message = Magic.cast_stance(combatant, target, spell, rounds, stance)
                messages.concat message
              end

              #Roll
              if roll
                message = Magic.cast_combat_roll(combatant, target, spell, effect)
                messages.concat message
              end

            #End Protection Rolls
            end
          #End targets.each do  (if spell succeeds)
          end
        elsif self.spell == "Phoenix's Healing Flames"
          messages.concat [t('magic.cast_phoenix_heal', :name => self.name, :spell => self.spell, :succeeds => "%xgSUCCEEDS%xn")]
        else
          #Spell fails
          messages.concat [t('magic.spell_target_resolution_msg', :name => self.name, :spell => spell, :target => print_target_names, :succeeds => succeeds)]
        end
        level = Global.read_config("spells", self.spell, "level")
        if level == 8
          messages.concat [t('magic.level_eight_fatigue', :name => self.name)]
        end
        messages
      end
    end
  end
end
