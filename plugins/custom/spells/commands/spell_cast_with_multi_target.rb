module AresMUSH
  module Custom
    class SpellCastWithMultiTargetCmd
      include CommandHandler
      attr_accessor :name, :target, :target_name, :target_combat, :spell, :spell_list, :caster, :caster_combat

      def parse_args
        self.spell_list = Global.read_config("spells")
        if (cmd.args =~ /\//)
          # Forcing NPC or PC to cast
          args = cmd.parse_args( /(?<arg1>[^\/]+)\/(?<arg2>[^\=]+)\=?(?<arg3>.+)?/)
          combat = enactor.combat
          caster_name = titlecase_arg(args.arg1)
          self.spell = titlecase_arg(args.arg2)
          self.target_name = titlecase_arg(args.arg3)
          #Returns char or NPC
          self.caster = FS3Combat.find_named_thing(caster_name, enactor)
          #Returns combatant
          if enactor.combat
            self.caster_combat = combat.find_combatant(caster_name)
          end

        else
          #Enactor casts
          args = cmd.parse_args(/(?<arg1>[^\=]+)\=?(?<arg2>.+)?/)
          self.spell = titlecase_arg(args.arg1)
          self.target_name = titlecase_arg(args.arg2)

          #Returns char or NPC
          self.caster = enactor


          # Returns combatant
          if enactor.combat
            self.caster_combat = enactor.combatant
          end
        end
      end

      def check_errors
        return t('custom.not_spell') if !self.spell_list.include?(self.spell)
        return t('custom.already_cast') if (self.caster.combat && Custom.already_cast(self.caster_combat)) == true
        multi_target = Global.read_config("spells", self.spell, "multi_target")
        return t('custom.not_multi_target') if !multi_target
        require_target = Global.read_config("spells", self.spell, "require_target")
        return t('custom.no_target') if !require_target
        is_res = Global.read_config("spells", self.spell, "is_res")

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

        if self.caster.combat
          if caster_combat.is_npc?
            return nil
          else
            return t('custom.dont_know_spell') if Custom.knows_spell?(caster, self.spell) == false
          end
          if self.caster_combat.is_ko
            client.emit_failure t('custom.spell_ko')
          else
            #Roll spell successes
            succeeds = Custom.roll_combat_spell_success(self.caster_combat, self.spell)

            #Healing Multiple Targets
            if heal_points
              Custom.cast_multi_heal(self.caster, self.target_name, self.spell)
            end



            self.caster_combat.update(has_cast: true)
            FS3Combat.set_action(client, self.caster_combat, self.caster.combat, self.caster_combat, FS3Combat::SpellAction, "")
          end

        else
          if heal_points
            if Custom.knows_spell?(caster, self.spell)
              Custom.cast_non_combat_heal(self.caster, self.target, self.spell)
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
