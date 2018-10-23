module AresMUSH
  module Custom
    class PotionUseCmd
    #potion/use <potion>
      include CommandHandler
      attr_accessor :potion, :potion_name, :spell, :roll, :caster, :caster_combat, :caster_name, :args

      # Using 'caster' even though it should probably be user or something just for variable consistency with helpers.
      def parse_args
          if (cmd.args =~ /\//)
          #Forcing NPC or PC to use potion
          args = cmd.parse_args(/(?<arg1>[^\/]+)\/(?<arg2>[^\+]+)/)
          combat = enactor.combat
          caster_name = titlecase_arg(args.arg1)
          #Returns char or NPC
          self.caster = FS3Combat.find_named_thing(caster_name, enactor)
          #Returns combatant
          if enactor.combat
            self.caster_combat = combat.find_combatant(caster_name)
            self.spell = titlecase_arg(args.arg2)
            self.potion_name = titlecase_arg(args.arg2)
          end
        else
           args = cmd.parse_args(/(?<arg1>[^\+]+)\+?(?<arg2>.+)?/)
           #Returns char or NPC
           caster_name = enactor.name
           self.caster = enactor
           self.spell = titlecase_arg(args.arg1)
           self.potion_name = titlecase_arg(args.arg1)

           #Returns combatant
           if enactor.combat
             self.caster_combat = enactor.combatant
           end
          end

          arg_array = [caster_name, potion_name]
          self.args = arg_array.join("/")
      end

      def check_errors
        return t('custom.not_character') if !caster
        # return t('custom.already_cast') if (enactor.combat && Custom.already_cast(self.caster_combat))

      end

      def handle
      #Reading Config
        # require_target = Global.read_config("spells", self.spell, "require_target")
        # weapon = Global.read_config("spells", self.spell, "weapon")
        # weapon_specials = Global.read_config("spells", self.spell, "weapon_specials")
        # armor = Global.read_config("spells", self.spell, "armor")
        # armor_specials = Global.read_config("spells", self.spell, "self.armor_specials")
        # is_stun = Global.read_config("spells", self.spell, "is_stun")
        roll = Global.read_config("spells", self.spell, "roll")
        # school = Global.read_config("spells", self.spell, "school")
        # spell_mod = Global.read_config("spells", self.spell, "spell_mod")
        heal_points = Global.read_config("spells", self.spell, "heal_points")
        # stance = Global.read_config("spells", self.spell, "stance")
        # lethal_mod = Global.read_config("spells", self.spell, "lethal_mod")
        # attack_mod = Global.read_config("spells", self.spell, "attack_mod")
        # defense_mod = Global.read_config("spells", self.spell, "defense_mod")

        if self.caster.combat
          if self.caster_combat.is_ko
            client.emit_failure t('custom.spell_ko')
          elsif (!caster_combat.is_npc? &&  !Custom.find_potion_has(caster, self.potion_name) )
              client.emit_failure t('custom.dont_have_potion')
          else
            FS3Combat.set_action(client, enactor, enactor.combat, caster_combat, FS3Combat::PotionAction, self.spell)

            # #Roll Spell in Combat
            # if roll == true
            #   Custom.potion_roll_spell(self.caster_combat, self.spell)
            # end
            #
            # #Equip Armor
            # if armor
            #   Custom.potion_equip_armor(enactor, self.caster_combat, self.spell)
            # end
            #
            # #Healing
            # if heal_points
            #   Custom.potion_heal(self.caster_combat, self.caster, self.spell)
            # end
            #
            # #Equip Weapon
            # if weapon
            #   Custom.potion_equip_weapon(enactor, self.caster_combat, self.spell)
            # end
            #
            # #Equip Weapon Specials
            # if weapon_specials
            #   Custom.potion_equip_weapon_specials(enactor, self.caster_combat, self.spell)
            # end
            #
            # #Stun
            # if is_stun
            #   Custom.potion_stun_spell(enactor, self.caster_combat, self.spell)
            # end
            #
            # #Change stance
            # if stance
            #   Custom.potion_stance(self.caster_combat, self.spell)
            # end
            #
            # #Set Lethal Mod
            # if lethal_mod
            #   Custom.potion_lethal_mod_with_target(self.caster_combat, self.spell)
            # end
            #
            # #Set defense mod
            # if defense_mod
            #   Custom.potion_defense_mod(self.caster_combat, self.spell)
            # end
            #
            # #Set attack mod
            # if attack_mod
            #   Custom.potion_attack_mod(self.caster_combat, self.spell)
            # end
            #
            #
            # #Set spell mod
            # if spell_mod
            #   Custom.potion_spell_mod(self.caster_combat, self.spell)
            # end


          end
        self.caster_combat.update(has_cast: true)
        elsif
          #Roll NonCombat
          if roll
            Custom.potion_noncombat_spell(self.caster, self.spell)
          elsif heal_points
            Custom.potion_non_combat_heal(self.caster, self.spell)
          else
            client.emit_failure t('custom.not_in_combat')
          end

        end


      end







    end
  end
end
