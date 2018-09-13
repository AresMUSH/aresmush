module AresMUSH
  module Custom
    class SpellCastWithTargetCmd
      include CommandHandler
      attr_accessor :name, :target, :spell, :spell_list, :caster

      def parse_args
        self.spell_list = Global.read_config("spells")
        if (cmd.args =~ /\//)
          args = cmd.parse_args( /(?<arg1>[^\/]+)\/(?<arg2>[^\=]+)\=?(?<arg3>.+)?/)
          combat = enactor.combat
          caster_name = titlecase_arg(args.arg1)
          self.spell = titlecase_arg(args.arg2)
          target_name = titlecase_arg(args.arg3)
          self.caster = combat.find_combatant(caster_name)
          self.target = combat.find_combatant(target_name)
        else
          args = cmd.parse_args(/(?<arg1>[^\=]+)\=?(?<arg2>.+)?/)
          self.caster = enactor.combatant
          self.spell = titlecase_arg(args.arg1)
          target_name = titlecase_arg(args.arg2)
          self.target = FS3Combat.find_named_thing(target_name, self.caster)
        end
        client.emit self.caster.name
        client.emit self.spell
        client.emit self.target.name
      end

      def check_errors
        require_target = Global.read_config("spells", self.spell, "require_target")
        return t('custom.not_spell') if !self.spell_list.include?(self.spell)
        return t('custom.already_cast') if Custom.already_cast(self.caster)
        return t('custom.no_target') if !require_target
        return t('custom.not_in_combat') if !self.caster.combat
        return nil
      end

      def handle
        if self.caster.is_ko
          client.emit_failure t('custom.spell_ko')
        else
        #Reading Config Files
          damage_desc = Global.read_config("spells", self.spell, "damage_desc")
          damage_inflicted = Global.read_config("spells", self.spell, "damage_inflicted")
          heal_points = Global.read_config("spells", self.spell, "heal_points")
          is_revive = Global.read_config("spells", self.spell, "is_revive")
          lethal_mod = Global.read_config("spells", self.spell, "lethal_mod")
          attack_mod = Global.read_config("spells", self.spell, "attack_mod")
          defense_mod = Global.read_config("spells", self.spell, "defense_mod")
          spell_mod = Global.read_config("spells", self.spell, "spell_mod")
          stance = Global.read_config("spells", self.spell, "stance")

          #Roll spell successes
          succeeds = Custom.roll_combat_spell_success(self.caster, self.spell)

          #Inflict damage
          if damage_inflicted
            Custom.cast_inflict_damage(self.caster, self.target, self.spell)
          end
          #Healing
          if heal_points
            Custom.cast_heal(self.caster, self.target, self.spell)
          end
          #Revive
          if is_revive
            if (!self.target.is_ko)
                  client.emit_failure t('custom.not_ko', :target => self.target.name)
            else
              Custom.cast_revive(self.caster, self.target, self.spell)
            end
          end

          #Set Lethal Mod
          if lethal_mod
            if succeeds == "%xgSUCCEEDS%xn"
              Custom.cast_lethal_mod(self.caster, self.target, self.spell)
            else
              FS3Combat.emit_to_combat self.caster.combat, t('custom.casts_spell', :name => self.caster.name, :spell => spell, :succeeds => succeeds)
            end
          end

          #Set defense mod
          if defense_mod
            if succeeds == "%xgSUCCEEDS%xn"
              Custom.cast_defense_mod(self.caster, self.target, self.spell)
            else
              FS3Combat.emit_to_combat self.caster.combat, t('custom.casts_spell', :name => self.caster.name, :spell => spell, :succeeds => succeeds)
            end
          end
          #Set attack mod
          if attack_mod
            if succeeds == "%xgSUCCEEDS%xn"
              Custom.cast_attack_mod(self.caster, self.target, self.spell)
            else
              FS3Combat.emit_to_combat self.caster.combat, t('custom.casts_spell', :name => self.caster.name, :spell => spell, :succeeds => succeeds)
            end
          end
          #Set spell mod
          if spell_mod
            if succeeds == "%xgSUCCEEDS%xn"
              Custom.cast_spell_mod(self.caster, self.target, self.spell)
            else
              FS3Combat.emit_to_combat self.caster.combat, t('custom.casts_spell', :name => self.caster.name, :spell => spell, :succeeds => succeeds)
            end
          end
          #Change stance
          if stance
            Custom.cast_stance(self.caster, self.target, self.spell)
          end
        self.caster.update(has_cast: true)
        FS3Combat.set_action(client, self.caster, self.caster.combat, self.caster, FS3Combat::SpellAction, "")
        end

      end

    end
  end
end
