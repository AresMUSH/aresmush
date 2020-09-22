module AresMUSH
  module FS3Combat
    class PotionAction < CombatAction
      attr_accessor  :spell, :target, :names, :potion, :has_target
      def prepare

        if (self.action_args =~ /\//)
          #Uses 'spell' instead of potion for easy c/p. Spell == potion.
          self.spell = self.action_args.before("/")
          self.names = self.action_args.after("/")
          self.has_target = true
        else
          self.names = self.name
          self.spell = self.action_args
        end

        self.spell = self.spell.titlecase
        self.potion = Magic.find_potion_has(combatant.associated_model, self.spell)

        error = self.parse_targets(self.names)
        return error if error
        return t('magic.dont_have_potion') if (!combatant.is_npc? && !self.potion)
        return t('fs3combat.only_one_target') if (self.targets.count > 1)
        targets.each do |target|
          heal_points = Global.read_config("spells", self.spell, "heal_points")
          wound = FS3Combat.worst_treatable_wound(target.associated_model)
          return t('magic.no_healable_wounds', :target => target.name) if (heal_points && wound.blank?)
        end
        return nil
      end

      def print_action
        if self.has_target
          msg = t('magic.potion_action_target_msg_long', :name => self.name, :potion => self.spell, :target => print_target_names)
        else
          msg = t('magic.potion_action_msg_long', :name => self.name, :potion => self.spell)
        end
      end

      def print_action_short
        t('magic.potion_action_target_msg_short', :target => print_target_names)
      end

      def resolve
        messages = []
        weapon = Global.read_config("spells", self.spell, "weapon")
        weapon_specials_str = Global.read_config("spells", self.spell, "weapon_specials")
        armor = Global.read_config("spells", self.spell, "armor")
        armor_specials_str = Global.read_config("spells", self.spell, "armor_specials")
        heal_points = Global.read_config("spells", self.spell, "heal_points")
        lethal_mod = Global.read_config("spells", self.spell, "lethal_mod")
        attack_mod = Global.read_config("spells", self.spell, "attack_mod")
        defense_mod = Global.read_config("spells", self.spell, "defense_mod")
        spell_mod = Global.read_config("spells", self.spell, "spell_mod")
        stance = Global.read_config("spells", self.spell, "stance")
        roll = Global.read_config("spells", self.spell, "roll")
        rounds = Global.read_config("spells", self.spell, "rounds")

        succeeds = "%xgSUCCEEDS%xn"

        targets.each do |target|

          #Healing
          if heal_points
            wound = FS3Combat.worst_treatable_wound(target.associated_model)
            if (wound)
              if target.death_count > 0
                messages.concat [t('magic.potion_ko_heal', :name => self.name, :target => target.name, :potion => self.spell, :points => heal_points)]
              else
                messages.concat [t('magic.potion_heal', :name => self.name, :target => target.name, :potion => self.spell, :points => heal_points)]
              end
              FS3Combat.heal(wound, heal_points)
            else
               messages.concat [t('magic.potion_heal_no_effect', :name => self.name, :potion => self.spell)]
            end
            target.update(death_count: 0  )
          end

          #Equip Weapon
          if (weapon && weapon != "Spell")
            FS3Combat.set_weapon(combatant, target, weapon)
            if armor

            else
              if target.name == combatant.name
                messages.concat [t('magic.use_potion', :name => self.name, :potion => self.spell)]
              else
                messages.concat [t('magic.use_potion_target', :name => self.name, :target => target.name, :potion => self.spell)]
              end
            end
          end

          #Equip Weapon Specials
          if weapon_specials_str
            Magic.set_spell_weapon_effects(self.combatant, self.spell)
            weapon = self.combatant.weapon.before("+")
            FS3Combat.set_weapon(nil, target, weapon, [weapon_specials_str])
            if heal_points

            elsif lethal_mod || defense_mod || attack_mod || spell_mod

            else
              if target.name == combatant.name
                messages.concat [t('magic.use_potion', :name => self.name, :potion => self.spell)]
              else
                messages.concat [t('magic.use_potion_target', :name => self.name, :target => target.name, :potion => self.spell)]
              end
            end
          end

          #Equip Armor
          if armor
            FS3Combat.set_armor(combatant, target, armor)
            if target.name == combatant.name
              messages.concat [t('magic.use_potion', :name => self.name, :potion => self.spell)]
            else
              messages.concat [t('magic.use_potion_target', :name => self.name, :target => target.name, :potion => self.spell)]
            end
          end

          #Equip Armor Specials
          if armor_specials_str
            armor_specials = armor_specials_str ? armor_specials_str.split('+') : nil
            FS3Combat.set_armor(combatant, target, target.armor, armor_specials)
            if target.name == combatant.name
              messages.concat [t('magic.use_potion', :name => self.name, :potion => self.spell)]
            else
              messages.concat [t('magic.use_potion_target', :name => self.name, :target => target.name, :potion => self.spell)]
            end
          end


          #Apply Mods
          if lethal_mod
            target.update(lethal_mod_counter: rounds)
            target.update(damage_lethality_mod: lethal_mod)
            if target.name == combatant.name
              messages.concat  [t('magic.potion_mod', :name => self.name, :potion => self.spell, :mod => target.damage_lethality_mod, :type => "lethality")]
            else
              messages.concat  [t('magic.potion_mod_target', :name => self.name, :potion => self.spell, :target => target.name, :mod => target.damage_lethality_mod, :type => "lethality")]
            end
          end

          if attack_mod
            target.update(attack_mod_counter: rounds)
            target.update(attack_mod: attack_mod)
            if target.name == combatant.name
              messages.concat  [t('magic.potion_mod', :name => self.name, :potion => self.spell, :mod => target.attack_mod, :type => "attack")]
            else
              messages.concat  [t('magic.potion_mod_target', :name => self.name, :potion => self.spell, :target => target.name, :mod => target.attack_mod, :type => "attack")]
            end
          end

          if defense_mod
            target.update(defense_mod_counter: rounds)
            target.update(defense_mod: defense_mod)
            if target.name == combatant.name
              messages.concat  [t('magic.potion_mod', :name => self.name, :potion => self.spell, :mod => target.defense_mod, :type => "defense")]
            else
              messages.concat  [t('magic.potion_mod_target', :name => self.name, :potion => self.spell, :target => target.name, :mod => target.defense_mod, :type => "defense")]
            end
          end

          if spell_mod
            target.update(spell_mod_counter: rounds)
            target.update(spell_mod: spell_mod)
            if target.name == combatant.name
              messages.concat  [t('magic.potion_mod', :name => self.name, :potion => self.spell, :mod => target.spell_mod, :type => "spell")]
            else
              messages.concat  [t('magic.potion_mod_target', :name => self.name, :potion => self.spell, :target => target.name, :mod => target.spell_mod, :type => "spell")]
            end
          end

          #Change Stance
          if stance
            target.update(stance: stance)
            target.update(stance_counter: rounds)
            target.update(stance_spell: self.spell)
            if target.name == combatant.name
              messages.concat [t('magic.potion_stance', :name => self.name, :potion => self.spell, :stance => stance, :rounds => rounds)]
            else
              messages.concat [t('magic.potion_stance_target', :name => self.name, :potion => self.spell, :target => target.name, :stance => stance, :rounds => rounds)]
            end
          end

          #Roll
          if roll
            if target.name == combatant.name
              messages.concat [t('magic.use_potion', :name => self.name, :potion => self.spell)]
            else
              messages.concat [t('magic.use_potion_target', :name => self.name, :target => target.name, :potion => self.spell)]
            end
          end

          if !combatant.is_npc?
            potion = Magic.find_potion_has(combatant.associated_model, self.spell)
            potion.delete
          end

        end

        messages

      end
    end
  end
end
