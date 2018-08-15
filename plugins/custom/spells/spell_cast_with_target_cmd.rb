module AresMUSH
  module Custom
    class SpellCastWithTargetCmd
      include CommandHandler
      attr_accessor :name, :target_name, :spell, :spell_list

      def parse_args
       args = cmd.parse_args(ArgParser.arg1_equals_arg2)
       self.spell = titlecase_arg(args.arg1)
       self.target_name = titlecase_arg(args.arg2)
       self.spell_list = Global.read_config("spells")
      end

      def check_errors
        require_target = Global.read_config("spells", self.spell, "require_target")
        return t('custom.not_spell') if !self.spell_list.include?(self.spell)
        return t('custom.already_cast') if Custom.already_cast(enactor)
        return t('custom.no_target') if !require_target
        return t('custom.not_in_combat') if !enactor.combat
        return nil
      end

      def handle
        if enactor.combatant.is_ko
          client.emit_failure t('custom.spell_ko')
        else
        #Reading Config Files
          caster = enactor
          target = FS3Combat.find_named_thing(self.target_name, enactor)
          damage_desc = Global.read_config("spells", self.spell, "damage_desc")
          damage_inflicted = Global.read_config("spells", self.spell, "damage_inflicted")
          heal_points = Global.read_config("spells", self.spell, "heal_points")
          is_revive = Global.read_config("spells", self.spell, "is_revive")
          lethal_mod = Global.read_config("spells", self.spell, "lethal_mod")
          attack_mod = Global.read_config("spells", self.spell, "attack_mod")
          defense_mod = Global.read_config("spells", self.spell, "defense_mod")
          spell_mod = Global.read_config("spells", self.spell, "spell_mod")
          stance = Global.read_config("spells", self.spell, "stance")

          #Inflict damage
          if damage_inflicted
            Custom.cast_inflict_damage(caster, target, self.spell)
          end
          #Healing
          if heal_points
            Custom.cast_heal(caster, target, self.spell)
          end
          #Revive
          if is_revive
            if (!target.combatant.is_ko)
                  client.emit_failure t('custom.not_ko', :target => target.name)
            else
              Custom.cast_revive(caster, target, self.spell)
            end
          end

          #Set Lethal Mod
          if lethal_mod
            if succeeds == "%xgSUCCEEDS%xn"
              current_mod = target.combatant.damage_lethality_mod
              new_mod = current_mod + lethal_mod
              target.combatant.update(damage_lethality_mod: new_mod)
              FS3Combat.emit_to_combat enactor.combat, t('cast_mod', :name => enactor.name, :spell => self.spell, :succeeds => succeeds, :target => target, :mod => lethal_mod, :type => "lethality", :total_mod => target.combatant.damage_lethality_mod)
            else
              FS3Combat.emit_to_combat enactor.combat, t('custom.casts_spell', :name => enactor.name, :spell => spell, :succeeds => succeeds)
            end
            FS3Combat.set_action(client, enactor, enactor.combat, enactor.combatant, FS3Combat::SpellAction, "")
          end

          #Set defense mod
          if defense_mod
            if succeeds == "%xgSUCCEEDS%xn"
              current_mod = target.combatant.defense_mod
              new_mod = current_mod + defense_mod
              client.emit "WTF"
              target.combatant.update(defense_mod: new_mod)
              FS3Combat.emit_to_combat enactor.combat, t('custom.cast_mod', :name => enactor.name, :target => target.name, :spell => self.spell, :succeeds => succeeds, :mod => defense_mod, :type => "defense", :total_mod => target.combatant.defense_mod)
            else
              FS3Combat.emit_to_combat enactor.combat, t('custom.casts_spell', :name => enactor.name, :spell => spell, :succeeds => succeeds)
            end
            FS3Combat.set_action(client, enactor, enactor.combat, enactor.combatant, FS3Combat::SpellAction, "")
          end
          #Set attack mod
          if attack_mod
            if succeeds == "%xgSUCCEEDS%xn"
              current_mod = target.combatant.attack_mod
              new_mod = current_mod + attack_mod
              target.combatant.update(attack_mod: new_mod)
              FS3Combat.emit_to_combat enactor.combat, t('custom.cast_mod', :name => enactor.name, :target => target.name, :spell => self.spell, :succeeds => succeeds, :mod => attack_mod, :type => "attack", :total_mod => target.combatant.attack_mod)
            else
              FS3Combat.emit_to_combat enactor.combat, t('custom.casts_spell', :name => enactor.name, :spell => spell, :succeeds => succeeds)
            end
            FS3Combat.set_action(client, enactor, enactor.combat, enactor.combatant, FS3Combat::SpellAction, "")
          end
          #Set spell mod
          if spell_mod
            if succeeds == "%xgSUCCEEDS%xn"
              current_mod = target.combatant.spell_mod.to_i
              new_mod = current_mod + spell_mod
              target.combatant.update(spell_mod: new_mod)
              FS3Combat.emit_to_combat enactor.combat, t('custom.cast_mod', :name => enactor.name, :target => target.name, :spell => self.spell, :succeeds => succeeds, :mod => spell_mod, :type => "spell", :total_mod => target.combatant.spell_mod)
            else
              FS3Combat.emit_to_combat enactor.combat, t('custom.casts_spell', :name => enactor.name, :spell => spell, :succeeds => succeeds)
            end
            FS3Combat.set_action(client, enactor, enactor.combat, enactor.combatant, FS3Combat::SpellAction, "")
          end
          #Change stance
          if stance
            if succeeds == "%xgSUCCEEDS%xn"
              target.combatant.update(stance: stance)
              FS3Combat.emit_to_combat enactor.combat, t('custom.cast_stance', :name => enactor.name, :target => target.name, :spell => self.spell, :succeeds => succeeds, :stance => stance)
            else
              FS3Combat.emit_to_combat enactor.combat, t('custom.casts_spell', :name => enactor.name, :spell => spell, :succeeds => succeeds)
            end
            FS3Combat.set_action(client, enactor, enactor.combat, enactor.combatant, FS3Combat::SpellAction, "")
          end
        enactor.combatant.update(has_cast: true)
        FS3Combat.set_action(client, enactor, enactor.combat, enactor.combatant, FS3Combat::SpellAction, "")
        end

      end

    end
  end
end
