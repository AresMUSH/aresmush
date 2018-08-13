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
          damage_desc = Global.read_config("spells", self.spell, "damage_desc")
          damage_inflicted = Global.read_config("spells", self.spell, "damage_inflicted")
          heal_points = Global.read_config("spells", self.spell, "heal_points")
          is_revive = Global.read_config("spells", self.spell, "is_revive")
          lethal_mod = Global.read_config("spells", self.spell, "lethal_mod")
          attack_mod = Global.read_config("spells", self.spell, "attack_mod")
          defense_mod = Global.read_config("spells", self.spell, "defense_mod")
          spell_mod = Global.read_config("spells", self.spell, "spell_mod")
          stance = Global.read_config("spells", self.spell, "stance")
          school = Global.read_config("spells", self.spell, "school")
          target = FS3Combat.find_named_thing(self.target_name, enactor)

          #Roll for success          
          die_result = Custom.roll_combat_spell(enactor, enactor.combatant, school)
          spell = self.spell
          succeeds = Custom.combat_spell_success(spell, die_result)

          #Inflict damage
          if damage_inflicted
            if succeeds == "%xgSUCCEEDS%xn"
              FS3Combat.inflict_damage(target, damage_inflicted, damage_desc)
              FS3Combat.emit_to_combat enactor.combat, t('custom.cast_damage', :name => enactor.name, :spell => self.spell, :succeeds => succeeds, :target => target.name, :damage_desc => self.spell.downcase)
            else
                FS3Combat.emit_to_combat enactor.combat, t('custom.casts_spell', :name => enactor.name, :spell => spell, :succeeds => succeeds)
            end
            FS3Combat.set_action(client, enactor, enactor.combat, enactor.combatant, FS3Combat::SpellAction, "")
          end
          #Healing
          if heal_points
            if succeeds == "%xgSUCCEEDS%xn"
              wound = FS3Combat.worst_treatable_wound(target)
              if (wound)
                FS3Combat.heal(wound, heal_points)
                FS3Combat.emit_to_combat enactor.combat, t('custom.cast_heal', :name => enactor.name, :spell => self.spell, :succeeds => succeeds, :target => target.name, :points => heal_points)
              else
                FS3Combat.emit_to_combat enactor.combat, t('custom.cast_heal_no_effect', :name => enactor.name, :spell => self.spell, :succeeds => succeeds, :target => target.name)
              end
            else
                FS3Combat.emit_to_combat enactor.combat, t('custom.casts_spell', :name => enactor.name, :spell => spell, :succeeds => succeeds)
            end
            FS3Combat.set_action(client, enactor, enactor.combat, enactor.combatant, FS3Combat::SpellAction, "")
          end
          #Revive
          if is_revive
            if (!target.combatant.is_ko)
                  client.emit_failure "#{target.name} is not knocked out."
            elsif succeeds == "%xgSUCCEEDS%xn"
              target.combatant.update(is_ko: false)
              FS3Combat.emit_to_combat enactor.combat, t('custom.cast_revive', :name => enactor.name, :spell => self.spell, :succeeds => succeeds, :target => target.name)
              FS3Combat.emit_to_combatant target.combatant, t('custom.been_revived', :name => enactor.name)
            else
              FS3Combat.emit_to_combat enactor.combat, t('custom.casts_spell', :name => enactor.name, :spell => spell, :succeeds => succeeds)
            end
            FS3Combat.set_action(client, enactor, enactor.combat, enactor.combatant, FS3Combat::SpellAction, "")
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

        end

      end

    end
  end
end
