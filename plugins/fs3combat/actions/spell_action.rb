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

        spell_list = Global.read_config("spells")
        return t('magic.not_spell') if !spell_list.include?(self.spell)
        if !combatant.is_npc?
          item_spells = Magic.item_spells(combatant.associated_model) || []
          return t('magic.dont_know_spell') if (Magic.knows_spell?(combatant, self.spell) == false && !item_spells.include?(spell))
        end
        num = Global.read_config("spells", self.spell, "target_num")
        return t('magic.too_many_targets', :spell => self.spell, :num => num) if (self.targets.count > num) if self.target_optional
        return t('magic.doesnt_use_target') if (self.target_optional.nil? && self.names != self.name)
        is_res = Global.read_config("spells", self.spell, "is_res")
        is_revive = Global.read_config("spells", self.spell, "is_revive")

        targets.each do |target|
          return t('magic.dont_target_self') if target == combatant && Global.read_config("spells", self.spell, "fs3_attack")
          return t('magic.not_dead', :target => target.name) if (is_res && !target.associated_model.dead)
          return t('magic.not_ko', :target => target.name) if (is_revive && !target.is_ko)
          wound = FS3Combat.worst_treatable_wound(target.associated_model)
          heal_points = Global.read_config("spells", self.spell, "heal_points")
          return t('magic.no_healable_wounds', :target => target.name) if (heal_points && wound.blank?)
          # Check that weapon specials can be added to weapon
          weapon_specials_str = Global.read_config("spells", self.spell, "weapon_specials")
          if weapon_specials_str
            weapon_special_group = FS3Combat.weapon_stat(target.weapon, "special_group") || ""
            weapon_allowed_specials = Global.read_config("fs3combat", "weapon special groups", weapon_special_group) || []
            return t('magic.cant_cast_on_gear', :spell => self.spell, :target => target.name, :gear => "weapon") if !weapon_allowed_specials.include?(weapon_specials_str.downcase)
          end
          #Check that armor specials can be added to weapon
          armor_specials_str = Global.read_config("spells", self.spell, "armor_specials")
          if armor_specials_str
            armor_allowed_specials = FS3Combat.armor_stat(target.armor, "allowed_specials") || []
            return t('magic.cant_cast_on_gear', :spell => self.spell, :target => target.name, :gear => "armor") if !armor_allowed_specials.include?(armor_specials_str)
          end

        end
        return nil
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
        armor = Global.read_config("spells", self.spell, "armor")
        armor_specials_str = Global.read_config("spells", self.spell, "armor_specials")
        attack_mod = Global.read_config("spells", self.spell, "attack_mod")
        damage_inflicted = Global.read_config("spells", self.spell, "damage_inflicted")
        damage_desc = Global.read_config("spells", spell, "damage_desc")
        damage_type = Global.read_config("spells", self.spell, "damage_type")
        defense_mod = Global.read_config("spells", self.spell, "defense_mod")
        init_mod = Global.read_config("spells", self.spell, "init_mod")
        damage_type = Global.read_config("spells", self.spell, "damage_type")
        fs3_attack = Global.read_config("spells", self.spell, "fs3_attack")
        heal_points = Global.read_config("spells", self.spell, "heal_points")
        is_revive = Global.read_config("spells", self.spell, "is_revive")
        is_res = Global.read_config("spells", self.spell, "is_res")
        is_stun = Global.read_config("spells", self.spell, "is_stun")
        lethal_mod = Global.read_config("spells", self.spell, "lethal_mod")
        roll = Global.read_config("spells", self.spell, "roll")
        rounds = Global.read_config("spells", self.spell, "rounds")
        spell_mod = Global.read_config("spells", self.spell, "spell_mod")
        stance = Global.read_config("spells", self.spell, "stance")
        school = Global.read_config("spells", self.spell, "school")
        target_optional = Global.read_config("spells", self.spell, "target_optional")
        weapon = Global.read_config("spells", self.spell, "weapon")
        weapon_specials_str = Global.read_config("spells", self.spell, "weapon_specials")

        messages = []
        combatant.log "~* #{self.combatant.name.upcase} CASTING #{self.spell.upcase} *~"

        succeeds = Magic.roll_combat_spell_success(combatant, spell)
        #The roll_combat_spell_success handles combat mods via roll_combat_spell

        if (fs3_attack || is_stun)

          if succeeds[:succeeds] == "%xgSUCCEEDS%xn"
            #Weapon
            if (weapon && weapon != "Spell")
              FS3Combat.set_weapon(combatant, combatant, weapon)
            end

            weapon_type = FS3Combat.weapon_stat(self.combatant.weapon, "weapon_type")


            #Spells roll for success individually because they only do one thing, and need to use different measures of success. Also, because weapon changes are on the caster, not the target.
            targets.each do |target|


              #Stun
              if is_stun
                message = Magic.cast_stun(self.combatant, target, self.spell, rounds, result = succeeds[:result])
                messages.concat message
              #Attacks
              elsif weapon_type == "Explosive"
                message = Magic.cast_explosion(self.combatant, target, self.spell, result = succeeds[:result])
                messages.concat message
              elsif weapon_type == "Suppressive"
                message = Magic.cast_suppress(self.combatant, target, self.spell, succeeds[:result])
                messages.concat message
              else
                message = Magic.cast_attack_target(self.combatant, target, result = succeeds[:result])
                messages.concat message
              end
            end
          else
            messages.concat [t('magic.spell_target_resolution_msg', :name =>  combatant.name, :spell => self.spell, :target => print_target_names, :succeeds => "%xrFAILS%xn")]
          end
        else
          # succeeds = Magic.roll_combat_spell_success(combatant, spell)
          #Spells here do not roll for success individually because they may do more than one thing and so need one success roll.
          if succeeds[:succeeds] == "%xgSUCCEEDS%xn"

            targets.each do |target|

              #Psionic Protection
              if self.spell == "Mind Shield"
                message = Magic.cast_mind_shield(combatant, target, self.spell, rounds, succeeds[:result])
                messages.concat message
              end

              #Fire Protection
               if self.spell == "Endure Fire"
                 message = Magic.cast_endure_fire(combatant, target, self.spell, rounds, succeeds[:result])
                 messages.concat message
               end

              #Cold Protection
              if self.spell == "Endure Cold"
                message = Magic.cast_endure_cold(combatant, target, self.spell, rounds, succeeds[:result])
                messages.concat message
              end

              #Healing
              if heal_points
                message = Magic.cast_combat_heal(combatant, target, self.spell, heal_points)
                messages.concat message
              end

              #Equip Weapon
              if (weapon && weapon != "Spell")
                message = Magic.cast_weapon(combatant, target, self.spell, weapon)
                messages.concat message
              end

              #Equip Weapon Specials
              if weapon_specials_str
                message = Magic.cast_weapon_specials(combatant, target, self.spell, weapon_specials_str)
                messages.concat message
              end

              #Equip Armor
              if armor
                message = Magic.cast_armor(combatant, target, self.spell, armor)
                messages.concat message
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

              if init_mod
                message = Magic.cast_init_mod(combatant, target, spell, rounds, init_mod)
                messages.concat message
              end

              #Change Stance
              if stance
                message = Magic.cast_stance(combatant, target, spell, rounds, stance)
                messages.concat message
              end

              #Roll
              if roll
                message = Magic.cast_combat_roll(combatant, target, spell, damage_type, succeeds[:result])
                messages.concat message
              end
            #End targets.each do for non FS3 spells (if spell succeeds)
            end
          #Spell fails
          else
            messages.concat [t('magic.spell_target_resolution_msg', :name =>  combatant.name, :spell => self.spell, :target => print_target_names, :succeeds => "%xrFAILS%xn")]
          #End spell rolls
          end
        # elsif self.spell == "Phoenix's Healing Flames"
        #   messages.concat [t('magic.cast_phoenix_heal', :name => self.name, :spell => self.spell, :succeeds => "%xgSUCCEEDS%xn")]
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
