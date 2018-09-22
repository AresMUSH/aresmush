module AresMUSH
  module Custom
    class PotionUseWithTargetCmd
    #potion/use <potion>=<target>
      include CommandHandler
      attr_accessor :potion, :potion_name, :potion, :roll, :spell, :caster, :target, :caster_combat, :target_combat, :target_name

      def parse_args
        if (cmd.args =~ /\//)
          #Forcing NPC or PC to cast
          args = cmd.parse_args( /(?<arg1>[^\/]+)\/(?<arg2>[^\=]+)\=?(?<arg3>.+)?/)
          combat = enactor.combat
          caster_name = titlecase_arg(args.arg1)
          self.spell = titlecase_arg(args.arg2)
          self.potion_name = titlecase_arg(args.arg2)
          self.target_name = titlecase_arg(args.arg3)
          #Returns char or NPC
          self.caster = FS3Combat.find_named_thing(caster_name, enactor)
          self.target = FS3Combat.find_named_thing(target_name, enactor)

          #Returns combatant
          if enactor.combat
            self.target_combat = combat.find_combatant(self.target_name)
            self.caster_combat = combat.find_combatant(caster_name)
          end

        else
          #Enactor casts
          args = cmd.parse_args(/(?<arg1>[^\=]+)\=?(?<arg2>.+)?/)
          self.potion_name = titlecase_arg(args.arg1)
          self.spell = titlecase_arg(args.arg1)
          self.target_name = titlecase_arg(args.arg2)

          #Returns char or NPC
          self.caster = enactor
          self.target = FS3Combat.find_named_thing(self.target_name, self.caster)

          #Returns combatant
          if enactor.combat
            combat = enactor.combat
            self.caster_combat = enactor.combatant
            self.target_combat = combat.find_combatant(target_name)
          end

        end
        self.potion = Custom.find_potion_has(enactor, self.potion_name)
      end

      def check_errors
        return t('custom.already_cast') if (enactor.combat && Custom.already_cast(self.caster_combat))
        return t('custom.invalid_name') if !self.target
      end

      def handle
      #Reading Config
        require_target = Global.read_config("spells", self.spell, "require_target")
        weapon = Global.read_config("spells", self.spell, "weapon")
        weapon_specials = Global.read_config("spells", self.spell, "weapon_specials")
        armor = Global.read_config("spells", self.spell, "armor")
        armor_specials = Global.read_config("spells", self.spell, "self.armor_specials")
        is_stun = Global.read_config("spells", self.spell, "is_stun")
        roll = Global.read_config("spells", self.spell, "roll")
        damage_inflicted = Global.read_config("spells", self.spell, "damage_inflicted")
        school = Global.read_config("spells", self.spell, "school")
        spell_mod = Global.read_config("spells", self.spell, "spell_mod")
        heal_points = Global.read_config("spells", self.spell, "heal_points")
        is_revive = Global.read_config("spells", self.spell, "is_revive")
        stance = Global.read_config("spells", self.spell, "stance")
        lethal_mod = Global.read_config("spells", self.spell, "lethal_mod")
        attack_mod = Global.read_config("spells", self.spell, "attack_mod")
        defense_mod = Global.read_config("spells", self.spell, "defense_mod")
        spell_mod = Global.read_config("spells", self.spell, "spell_mod")
        if self.caster.combat
          if self.caster_combat.is_ko
            client.emit_failure t('custom.spell_ko')
          elsif (!caster_combat.is_npc? &&  !Custom.find_potion_has(caster, self.potion_name))
            client.emit_failure t('custom.dont_have_potion')
          else

            #Inflict damage
            if damage_inflicted
              Custom.potion_inflict_damage(self.caster_combat, self.target, self.spell)
            end

            #Healing
            if heal_points
              Custom.potion_heal_with_target(self.caster_combat, self.target, self.spell)
            end

            #Revive
            if is_revive
              if (!self.target_combat.is_ko)
                    client.emit_failure t('custom.not_ko', :target => self.target.name)
              else
                Custom.potion_revive(self.caster_combat, self.target_combat, self.spell)
              end
            end

            #Set Lethal Mod
            if lethal_mod
              Custom.potion_lethal_mod_with_target(self.caster, self.target_combat, self.spell)
            end

            #Set defense mod
            if defense_mod
              Custom.potion_defense_mod_with_target(self.caster, self.target_combat, self.spell)
            end

            #Set attack mod
            if attack_mod
              Custom.potion_attack_mod_with_target(self.caster, self.target_combat, self.spell)
            end

            #Set spell mod
            if spell_mod
              Custom.potion_spell_mod_with_target(self.caster, self.target_combat, self.spell)
            end

            #Change stance
            if stance
              Custom.potion_stance_with_target(self.caster_combat, self.target_combat, self.spell)
            end

            #Equip Armor
            if armor
              Custom.potion_equip_armor_with_target(enactor, self.caster_combat, self.target_combat, self.spell)
            end

            #Equip Armor Specials
            if armor_specials
              FS3Combat.emit_to_combat self.caster.combat, t('custom.use_potion_with_target', :name => self.caster.name, :potion => spell, :target => self.target.name)
                Custom.potion_equip_armor_specials_with_target(enactor, self.caster_combat, self.target_combat, self.spell)
            end

            #Equip Weapon
            if weapon
              Custom.potion_equip_weapon_with_target(enactor, self.caster_combat, self.target_combat, self.spell)
            end

            #Equip Weapon Specials
            if weapon_specials
              FS3Combat.emit_to_combat self.caster.combat, t('custom.use_potion_with_target', :name => self.caster.name, :potion => spell)
              Custom.potion_equip_weapon_specials_with_target(enactor, self.caster_combat, self.target_combat, self.spell)
            end
            # For some reason, both of these break setting weapons and armor. I have no idea why.

            self.caster_combat.update(has_cast: true)
            FS3Combat.set_action(client, self.caster_combat, self.caster.combat, self.caster_combat, FS3Combat::PotionAction, "")
          end


        else
          if heal_points
            if Custom.knows_spell?(caster, self.spell)
              Custom.potion_non_combat_heal_with_target(self.caster, self.target, self.spell)
            else
              client.emit_failure t('custom.dont_know_spell')
            end
          else
            client.emit_failure t('custom.not_in_combat')
          end
        end
        if caster == enactor
          self.potion.delete
        end

      end







    end
  end
end
