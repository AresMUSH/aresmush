module AresMUSH
  module Custom
    class SpellCastCmd
    #spell/cast <spell>
      include CommandHandler
      attr_accessor :name, :weapon_name, :spell, :spell_list, :weapon,  :caster, :caster_combat, :args, :mod
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
          args = cmd.parse_args(/(?<arg1>[^\+\-]+)(?<arg2>.+)?/)
          caster_name = enactor.name
          #Returns char or NPC
          self.caster = enactor
          self.spell = titlecase_arg(args.arg1)
          self.mod = args.arg2

          #Returns combatant
          if enactor.combat
            self.caster_combat = enactor.combatant
          end

        end
        arg_array = [caster_name, spell]
        self.args = arg_array.join("/")
      end

      def check_errors
        return t('custom.not_character') if !caster
        return t('custom.not_spell') if !self.spell_list.include?(self.spell)
        return t('custom.cant_force_cast') if (self.caster != enactor && !enactor.combatant)
        return t('fs3combat.must_escape_first') if (enactor.combat && caster_combat.is_subdued?)
        if enactor.combat

          return emit_failure t('custom.spell_ko') if self.caster_combat.is_ko
          return t('custom.dont_know_spell') if (!caster_combat.is_npc? &&  Custom.knows_spell?(caster, self.spell) == false && Custom.item_spell(caster) != self.spell)




          # Prevent badly config's spells from completely breaking combat by equipping non-existant gear
          weapon = Global.read_config("spells", self.spell, "weapon")
          return t('fs3combat.invalid_weapon') if (weapon && !FS3Combat.weapon(weapon))
          armor = Global.read_config("spells", self.spell, "armor")
          return t('fs3combat.invalid_armor') if (armor && !FS3Combat.armor(armor))

          #Check that weapon specials can be added to weapon
          weapon_specials_str = Global.read_config("spells", self.spell, "weapon_specials")
          if weapon_specials_str
            weapon_special_group = FS3Combat.weapon_stat(self.caster_combat.weapon, "special_group") || ""
            weapon_allowed_specials = Global.read_config("fs3combat", "weapon special groups", weapon_special_group) || []
            return t('custom.cant_cast_on_gear', :spell => self.spell, :target => self.caster_combat.name, :gear => "weapon") if !weapon_allowed_specials.include?(weapon_specials_str.downcase)
          end

          #Check that armor specials can be added to weapon
          armor_specials_str = Global.read_config("spells", self.spell, "armor_specials")
          if armor_specials_str
            armor_allowed_specials = FS3Combat.armor_stat(self.caster_combat.armor, "allowed_specials") || []
            return t('custom.cant_cast_on_gear', :spell => self.spell, :target => self.caster_combat.name, :gear => "armor") if !armor_allowed_specials.include?(armor_specials_str)
          end

        else
          return t('custom.dont_know_spell') if (Custom.knows_spell?(caster, self.spell) == false && Custom.item_spell(caster) != spell)

        end

        return nil
      end

      def handle
      #Reading Config Files
        roll = Global.read_config("spells", self.spell, "roll")
        heal_points = Global.read_config("spells", self.spell, "heal_points")

        if self.caster.combat
          FS3Combat.set_action(client, enactor, enactor.combat, caster_combat, FS3Combat::SpellAction, self.spell)
        else
          #Roll NonCombat
          if roll
            Custom.cast_noncombat_spell(self.caster, self.spell, self.mod)
          elsif heal_points
            Custom.cast_non_combat_heal(self.caster, self.spell, self.mod)
          else
            client.emit_failure t('custom.not_in_combat')
          end

        end


      end

    end
  end
end
