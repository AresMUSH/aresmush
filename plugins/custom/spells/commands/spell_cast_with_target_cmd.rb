module AresMUSH
  module Custom
    class SpellCastWithTargetCmd
      include CommandHandler
      attr_accessor :name, :target, :target_name, :target_combat, :spell, :spell_list, :caster, :caster_combat, :action_args, :mod

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
          # self.target = FS3Combat.find_named_thing(target_name, enactor)

          #Returns combatant
          if enactor.combat
            # self.target_combat = combat.find_combatant(self.target_name)
            self.caster_combat = combat.find_combatant(caster_name)
          end

        else
          #Enactor casts
          args = cmd.parse_args(/(?<arg1>[^\=]+)\=?(?<arg2>[^\+]+)\+?(?<arg3>.+)?/)
          self.spell = titlecase_arg(args.arg1)
          self.target_name = titlecase_arg(args.arg2)

          #Returns char or NPC
          self.caster = enactor
          self.target = FS3Combat.find_named_thing(self.target_name, self.caster)
          self.mod = args.arg3

          #Returns combatant
          if enactor.combat
            combat = enactor.combat
            self.caster_combat = enactor.combatant
            self.target_combat = combat.find_combatant(target_name)
          end
        end
        arg_array = [self.target_name, self.spell]
        self.action_args = arg_array.join("/")
      end

      def check_errors
        return t('custom.not_character') if !caster
        return t('custom.not_spell') if !self.spell_list.include?(self.spell)
        # return t('custom.already_cast') if (self.caster.combat && Custom.already_cast(self.caster_combat)) == true
        # return t('custom.invalid_name') if !self.target
        require_target = Global.read_config("spells", self.spell, "require_target")
        target_optional = Global.read_config("spells", self.spell, "target_optional")
        return t('custom.no_target') if (!require_target && !target_optional)
        heal_points = Global.read_config("spells", self.spell, "heal_points")
        # return t('custom.cant_heal_dead') if (heal_points && target.dead)
        # multi_target = Global.read_config("spells", self.spell, "multi_target")
        # return t('custom.needs_multi_target') if multi_target
        is_res = Global.read_config("spells", self.spell, "is_res")
        is_revive = Global.read_config("spells", self.spell, "is_revive")
        target_names = target_name.split(" ").map { |n| InputFormatter.titlecase_arg(n) }
        target_names.each do |name|
          target = enactor.combat.find_combatant(name)
          return t('fs3combat.not_in_combat', :name => name) if !target
          return t('custom.not_dead', :target => target.name) if (is_res && !target.associated_model.dead)
          return t('custom.not_ko', :target => target.name) if (is_revive && !target.is_ko)
        end

        weapon = Global.read_config("spells", self.spell, "weapon")
        return t('fs3combat.invalid_weapon') if (weapon && !FS3Combat.weapon(weapon))
        armor = Global.read_config("spells", self.spell, "armor")
        return t('fs3combat.invalid_armor') if (armor && !FS3Combat.armor(armor))

        return t('custom.caster_should_not_equal_target') if (self.caster.combat && self.caster_combat == self.target_combat)

        return nil
      end

      def handle
      #Reading Config Files
        # multi_target = Global.read_config("spells", self.spell, "multi_target")
        # damage_desc = Global.read_config("spells", self.spell, "damage_desc")
        # damage_inflicted = Global.read_config("spells", self.spell, "damage_inflicted")
        heal_points = Global.read_config("spells", self.spell, "heal_points")
        # is_revive = Global.read_config("spells", self.spell, "is_revive")
        # is_res = Global.read_config("spells", self.spell, "is_res")
        # lethal_mod = Global.read_config("spells", self.spell, "lethal_mod")
        # attack_mod = Global.read_config("spells", self.spell, "attack_mod")
        # defense_mod = Global.read_config("spells", self.spell, "defense_mod")
        # spell_mod = Global.read_config("spells", self.spell, "spell_mod")
        # stance = Global.read_config("spells", self.spell, "stance")
        weapon = Global.read_config("spells", self.spell, "weapon")
        # weapon_specials = Global.read_config("spells", self.spell, "weapon_specials")
        # armor = Global.read_config("spells", self.spell, "armor")
        # armor_specials = Global.read_config("spells", self.spell, "armor_specials")
        fs3_attack = Global.read_config("spells", self.spell, "fs3_attack")
        roll = Global.read_config("spells", self.spell, "roll")
        is_stun = Global.read_config("spells", self.spell, "is_stun")

        if self.caster.combat
          if self.caster_combat.is_ko
            client.emit_failure t('custom.spell_ko')
          elsif (!caster_combat.is_npc? &&  Custom.knows_spell?(caster, self.spell) == false && Custom.item_spell(caster) != spell)
              client.emit_failure t('custom.dont_know_spell')
          else


            #Equip Weapon with attack
            if fs3_attack
              if weapon
                FS3Combat.emit_to_combat caster_combat.combat, t('custom.will_cast_fs3_attack', :name => caster_combat.name, :spell => spell, :target => target_name), nil, true
                FS3Combat.set_weapon(enactor, caster_combat, weapon)
                weapon_type = FS3Combat.weapon_stat(caster_combat.weapon, "weapon_type")
                if is_stun
                  FS3Combat.set_action(client, enactor, enactor.combat, caster_combat, FS3Combat::SubdueAction, target_name)
                elsif weapon_type == "Explosive"
                  FS3Combat.set_action(client, enactor, enactor.combat, caster_combat, FS3Combat::ExplodeAction, target_name)
                elsif weapon_type == "Suppressive"
                  FS3Combat.set_action(client, enactor, enactor.combat, caster_combat, FS3Combat::SuppressAction, target_name)
                else
                  FS3Combat.set_action(client, enactor, enactor.combat, caster_combat, FS3Combat::AttackAction, target_name)
                end
              end
            else
              FS3Combat.set_action(client, enactor, enactor.combat, caster_combat, FS3Combat::SpellTargetAction, self.action_args)
            end


          end


        else
          if heal_points
            if Custom.knows_spell?(caster, self.spell)
              Custom.cast_non_combat_heal_with_target(self.caster, self.target, self.spell, self.mod)
            else
              client.emit_failure t('custom.dont_know_spell')
            end
          elsif roll
            if Custom.knows_spell?(caster, self.spell)
              Custom.cast_noncombat_roll_spell_with_target(self.caster, self.target, self.spell, self.mod)
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
