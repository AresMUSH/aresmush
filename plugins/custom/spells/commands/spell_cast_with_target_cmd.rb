module AresMUSH
  module Custom
    class SpellCastWithTargetCmd
      include CommandHandler
      attr_accessor :name, :target, :target_name, :target_combat, :spell, :spell_list, :caster, :caster_combat

      def parse_args
        self.spell_list = Global.read_config("spells")
        if (cmd.args =~ /\//)
          #Forcing NPC or PC to cast
          args = cmd.parse_args( /(?<arg1>[^\/]+)\/(?<arg2>[^\=]+)\=?(?<arg3>.+)?/)
          combat = enactor.combat
          caster_name = titlecase_arg(args.arg1)
          self.spell = titlecase_arg(args.arg2)
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

      end

      def check_errors
        return t('custom.not_spell') if !self.spell_list.include?(self.spell)
        return t('custom.already_cast') if (self.caster.combat && Custom.already_cast(self.caster_combat)) == true
        require_target = Global.read_config("spells", self.spell, "require_target")
        target_optional = Global.read_config("spells", self.spell, "target_optional")
        return t('custom.no_target') if (!require_target && !target_optional)
        multi_target = Global.read_config("spells", self.spell, "multi_target")
        return t('custom.needs_multi_target') if multi_target
        heal_points = Global.read_config("spells", self.spell, "heal_points")
        return t('custom.cant_heal_dead') if (heal_points && target.dead)
        is_res = Global.read_config("spells", self.spell, "is_res")
        return t('custom.not_dead', :target => target.name) if (is_res && !target.dead)
        return t('custom.caster_should_not_equal_target') if self.caster_combat == self.target_combat

        return nil
      end

      def handle
      #Reading Config Files
        multi_target = Global.read_config("spells", self.spell, "multi_target")
        damage_desc = Global.read_config("spells", self.spell, "damage_desc")
        damage_inflicted = Global.read_config("spells", self.spell, "damage_inflicted")
        heal_points = Global.read_config("spells", self.spell, "heal_points")
        is_revive = Global.read_config("spells", self.spell, "is_revive")
        is_res = Global.read_config("spells", self.spell, "is_res")
        lethal_mod = Global.read_config("spells", self.spell, "lethal_mod")
        attack_mod = Global.read_config("spells", self.spell, "attack_mod")
        defense_mod = Global.read_config("spells", self.spell, "defense_mod")
        spell_mod = Global.read_config("spells", self.spell, "spell_mod")
        stance = Global.read_config("spells", self.spell, "stance")
        weapon = Global.read_config("spells", self.spell, "weapon")
        weapon_specials = Global.read_config("spells", self.spell, "weapon_specials")
        armor = Global.read_config("spells", self.spell, "armor")
        armor_specials = Global.read_config("spells", self.spell, "armor_specials")

        if self.caster.combat
          if self.caster_combat.is_ko
            client.emit_failure t('custom.spell_ko')
          elsif (!caster_combat.is_npc? &&  Custom.knows_spell?(caster, self.spell) == false)
              client.emit_failure t('custom.dont_know_spell')
          else

            #Roll spell successes
            succeeds = Custom.roll_combat_spell_success(self.caster_combat, self.spell)
            #Inflict damage
            if damage_inflicted
              Custom.cast_inflict_damage(self.caster_combat, self.target, self.spell)
            end

            #Healing
            if heal_points
              Custom.cast_heal_with_target(self.caster_combat, self.target, self.spell)
            end

            #Revive
            if is_revive
              if (!self.target_combat.is_ko)
                    client.emit_failure t('custom.not_ko', :target => self.target.name)
              else
                Custom.cast_revive(self.caster_combat, self.target_combat, self.spell)
              end
            end

            #Resurrect
            if is_res
              succeeds = Custom.roll_combat_spell_success(caster_combat, spell)
              if self.target_combat.npc
                if succeeds == "%xgSUCCEEDS%xn"
                  FS3Combat.emit_to_combat caster.combat, t('custom.cast_res', :name => caster.name, :spell => spell, :succeeds => succeeds, :target => target.name)
                  client.emit_success t('custom.npc_rejoin', :target => target.name)
                else
                  FS3Combat.emit_to_combat caster.combat, t('custom.casts_spell', :name => caster.name, :spell => spell, :succeeds => succeeds)
                end
              else
                Custom.cast_revive(self.caster_combat, self.target, self.target_combat, self.spell)
              end
            end

            #Set Lethal Mod
            if lethal_mod
              if succeeds == "%xgSUCCEEDS%xn"
                Custom.cast_lethal_mod_with_target(self.caster, self.target_combat, self.spell)
              else
                FS3Combat.emit_to_combat self.caster.combat, t('custom.casts_spell', :name => self.caster.name, :spell => spell, :succeeds => succeeds)
              end
            end

            #Set defense mod
            if defense_mod
              if succeeds == "%xgSUCCEEDS%xn"
                Custom.cast_defense_mod_with_target(self.caster, self.target_combat, self.spell)
              else
                FS3Combat.emit_to_combat self.caster.combat, t('custom.casts_spell', :name => self.caster.name, :spell => spell, :succeeds => succeeds)
              end
            end

            #Set attack mod
            if attack_mod
              if succeeds == "%xgSUCCEEDS%xn"
                Custom.cast_attack_mod_with_target(self.caster, self.target_combat, self.spell)
              else
                FS3Combat.emit_to_combat self.caster.combat, t('custom.casts_spell', :name => self.caster.name, :spell => spell, :succeeds => succeeds)
              end
            end

            #Set spell mod
            if spell_mod
              if succeeds == "%xgSUCCEEDS%xn"
                Custom.cast_spell_mod_with_target(self.caster, self.target_combat, self.spell)
              else
                FS3Combat.emit_to_combat self.caster.combat, t('custom.casts_spell', :name => self.caster.name, :spell => spell, :succeeds => succeeds)
              end
            end

            #Change stance
            if stance
              Custom.cast_stance_with_target(self.caster_combat, self.target_combat, self.spell)
            end

            #Equip Armor
            if armor
              if succeeds == "%xgSUCCEEDS%xn"
                Custom.cast_equip_armor_with_target(enactor, self.caster_combat, self.target_combat, self.spell)
              else
                FS3Combat.emit_to_combat self.caster.combat, t('custom.casts_spell', :name => self.caster.name, :spell => spell, :succeeds => succeeds)
              end

            end

            #Equip Armor Specials
            if armor_specials
              if succeeds == "%xgSUCCEEDS%xn"
                FS3Combat.emit_to_combat self.caster.combat, t('custom.casts_spell', :name => self.caster.name, :spell => spell, :succeeds => succeeds)
                Custom.cast_equip_armor_specials_with_target(enactor, self.caster_combat, self.target_combat, self.spell)
              else
                FS3Combat.emit_to_combat self.caster.combat, t('custom.casts_spell', :name => self.caster.name, :spell => spell, :succeeds => succeeds)
              end
            end

            #Equip Weapon
            if weapon
              if succeeds == "%xgSUCCEEDS%xn"
                Custom.cast_equip_weapon_with_target(enactor, self.caster_combat, self.target_combat, self.spell)
              else
                FS3Combat.emit_to_combat self.caster.combat, t('custom.casts_spell', :name => self.caster.name, :spell => spell, :succeeds => succeeds)
              end
            end

            #Equip Weapon Specials
            if weapon_specials
              if succeeds == "%xgSUCCEEDS%xn"
                FS3Combat.emit_to_combat self.caster.combat, t('custom.casts_spell', :name => self.caster.name, :spell => spell, :succeeds => succeeds)
                Custom.cast_equip_weapon_specials_with_target(enactor, self.caster_combat, self.target_combat, self.spell)
              else
                FS3Combat.emit_to_combat self.caster.combat, t('custom.casts_spell', :name => self.caster.name, :spell => spell, :succeeds => succeeds)
              end
            end
            # For some reason, both of these break setting weapons and armor. I have no idea why.

            self.caster_combat.update(has_cast: true)
            FS3Combat.set_action(client, self.caster_combat, self.caster.combat, self.caster_combat, FS3Combat::SpellAction, "")
          end


        else
          if heal_points
            if Custom.knows_spell?(caster, self.spell)
              Custom.cast_non_combat_heal_with_target(self.caster, self.target, self.spell)
            else
              client.emit_failure t('custom.dont_know_spell')
            end
          else
            client.emit_failure t('custom.not_in_combat')
          end
        end

      end

    end
  end
end
