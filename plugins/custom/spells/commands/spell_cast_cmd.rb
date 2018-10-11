module AresMUSH
  module Custom
    class SpellCastCmd
    #spell/cast <spell>
      include CommandHandler
      attr_accessor :name, :weapon_name, :spell, :spell_list, :weapon,  :caster, :caster_combat
      def parse_args
       self.spell_list = Global.read_config("spells")
       if (cmd.args =~ /\//)
         #Forcing NPC or PC to cast
         args = cmd.parse_args(/(?<arg1>[^\/]+)\/(?<arg2>[^\+]+)/)
         combat = enactor.combat
         caster_name = titlecase_arg(args.arg1)
         #Returns char or NPC
         self.caster = FS3Combat.find_named_thing(caster_name, enactor)
         #Returns combatant
         if enactor.combat
           self.caster_combat = combat.find_combatant(caster_name)
           self.spell = titlecase_arg(args.arg2)
         end
       else
          args = cmd.parse_args(/(?<arg1>[^\+]+)\+?(?<arg2>.+)?/)
          #Returns char or NPC
          self.caster = enactor
          self.spell = titlecase_arg(args.arg1)
          #Returns combatant
          if enactor.combat
            self.caster_combat = enactor.combatant
          end

        end
      end

      def check_errors
        return t('custom.not_character') if !caster
        return t('custom.not_spell') if !self.spell_list.include?(self.spell)
        return t('custom.cant_force_cast') if (self.caster != enactor && !enactor.combatant)
        return t('custom.already_cast') if (enactor.combat && Custom.already_cast(self.caster_combat))
        require_target = Global.read_config("spells", self.spell, "require_target")
        multi_target = Global.read_config("spells", self.spell, "multi_target")
        return t('custom.needs_multi_target') if (require_target && multi_target)
        return t('custom.needs_target') if require_target
        return nil
      end

      def handle
      #Reading Config Files

        weapon = Global.read_config("spells", self.spell, "weapon")
        weapon_specials = Global.read_config("spells", self.spell, "weapon_specials")
        armor = Global.read_config("spells", self.spell, "armor")
        armor_specials = Global.read_config("spells", self.spell, "armor_specials")
        is_stun = Global.read_config("spells", self.spell, "is_stun")
        roll = Global.read_config("spells", self.spell, "roll")
        heal_points = Global.read_config("spells", self.spell, "heal_points")
        is_revive = Global.read_config("spells", self.spell, "is_revive")
        lethal_mod = Global.read_config("spells", self.spell, "lethal_mod")
        attack_mod = Global.read_config("spells", self.spell, "attack_mod")
        defense_mod = Global.read_config("spells", self.spell, "defense_mod")
        spell_mod = Global.read_config("spells", self.spell, "spell_mod")
        stance = Global.read_config("spells", self.spell, "stance")
        school = Global.read_config("spells", self.spell, "school")


        if self.caster.combat
          if self.caster_combat.is_ko
            client.emit_failure t('custom.spell_ko')
          elsif (!caster_combat.is_npc? &&  Custom.knows_spell?(caster, self.spell) == false)
              client.emit_failure t('custom.dont_know_spell')
          else
            #Roll spell successes
            succeeds = Custom.roll_combat_spell_success(self.caster_combat, self.spell)

            #Roll Spell in Combat
            if roll == true
              FS3Combat.set_action(client, enactor, enactor.combat, caster_combat, FS3Combat::RollSpellAction, self.spell)
            end

            #Equip Armor
            if armor
              Custom.cast_equip_armor(enactor, self.caster_combat, self.spell)
            end

            #Equip Armor Specials
            if armor_specials
              if succeeds == "%xgSUCCEEDS%xn"
                FS3Combat.emit_to_combat self.caster.combat, t('custom.casts_spell', :name => self.caster.name, :spell => spell, :succeeds => succeeds), nil, true
                Custom.cast_equip_armor_specials(enactor, self.caster_combat, self.spell)
              else
                FS3Combat.emit_to_combat self.caster.combat, t('custom.casts_spell', :name => self.caster.name, :spell => spell, :succeeds => succeeds), nil, true
              end
            end

            #Healing
            if heal_points
              Custom.cast_heal(self.caster_combat, self.caster, self.spell)
            end

            #Equip Weapon
            if weapon
              Custom.cast_equip_weapon(enactor, self.caster_combat, self.spell)
            end

            #Equip Weapon Specials
            if weapon_specials
              Custom.cast_equip_weapon_specials(enactor, self.caster_combat, self.spell)
            end

            #Stun
            if is_stun
              Custom.cast_stun_spell(enactor, self.caster_combat, self.spell)
            end

            #Change stance
            if stance
              Custom.cast_stance(self.caster_combat, self.spell)
            end

            #Set Lethal Mod
            if lethal_mod
              if succeeds == "%xgSUCCEEDS%xn"
                Custom.cast_lethal_mod_with_target(self.caster_combat, self.spell)
              else
                FS3Combat.emit_to_combat self.caster.combat, t('custom.casts_spell', :name => self.caster.name, :spell => spell, :succeeds => succeeds)
              end
            end

            #Set defense mod
            if defense_mod
              if succeeds == "%xgSUCCEEDS%xn"
                Custom.cast_defense_mod(self.caster_combat, self.spell)
              else
                FS3Combat.emit_to_combat self.caster.combat, t('custom.casts_spell', :name => self.caster.name, :spell => spell, :succeeds => succeeds), nil, true
              end
            end

            #Set attack mod
            if attack_mod
              if succeeds == "%xgSUCCEEDS%xn"
                Custom.cast_attack_mod(self.caster_combat, self.spell)
              else
                FS3Combat.emit_to_combat self.caster.combat, t('custom.casts_spell', :name => self.caster.name, :spell => spell, :succeeds => succeeds), nil, true
              end
            end


            #Set spell mod
            if spell_mod
              if succeeds == "%xgSUCCEEDS%xn"
                Custom.cast_spell_mod(self.caster_combat, self.spell)
              else
                FS3Combat.emit_to_combat self.caster.combat, t('custom.casts_spell', :name => self.caster.name, :spell => spell, :succeeds => succeeds), nil, true
              end
            end


          end
        self.caster_combat.update(has_cast: true)
        elsif
          #Roll NonCombat
          if roll

            Custom.cast_noncombat_spell(self.caster, self.spell)
          elsif heal_points
            Custom.cast_non_combat_heal(self.caster, self.spell)
          else
            client.emit_failure t('custom.not_in_combat')
          end

        end


      end

    end
  end
end
