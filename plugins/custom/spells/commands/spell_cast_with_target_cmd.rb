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
          args = cmd.parse_args(/(?<arg1>[^\=]+)\=?(?<arg2>[^\+\-]+)(?<arg3>.+)?/)
          self.spell = titlecase_arg(args.arg1)
          self.target_name = titlecase_arg(args.arg2)
          self.mod = args.arg3

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
        arg_array = [self.target_name, self.spell]
        self.action_args = arg_array.join("/")
      end

      def check_errors
        return t('custom.not_character') if !caster
        return t('custom.not_spell') if !self.spell_list.include?(self.spell)
        require_target = Global.read_config("spells", self.spell, "require_target")
        target_optional = Global.read_config("spells", self.spell, "target_optional")
        return t('custom.no_target') if (!require_target && !target_optional)
        heal_points = Global.read_config("spells", self.spell, "heal_points")
        is_res = Global.read_config("spells", self.spell, "is_res")
        is_revive = Global.read_config("spells", self.spell, "is_revive")
        target_names = target_name.split(" ").map { |n| InputFormatter.titlecase_arg(n) }
        if enactor.combat
          return emit_failure t('custom.spell_ko') if self.caster_combat.is_ko
          return t('custom.dont_know_spell') if (!caster_combat.is_npc? &&  Custom.knows_spell?(caster, self.spell) == false && Custom.item_spell(caster) != self.spell)

          target_names.each do |name|
            target = enactor.combat.find_combatant(name)
            return t('fs3combat.not_in_combat', :name => name) if !target
            return t('custom.not_dead', :target => target.name) if (is_res && !target.associated_model.dead)
            return t('custom.not_ko', :target => target.name) if (is_revive && !target.is_ko)
            #Check that weapon specials can be added to weapon
            weapon_specials_str = Global.read_config("spells", self.spell, "weapon_specials")
            if weapon_specials_str
              weapon_special_group = FS3Combat.weapon_stat(target.weapon, "special_group") || ""
              weapon_allowed_specials = Global.read_config("fs3combat", "weapon special groups", weapon_special_group) || []
              return t('custom.cant_cast_on_gear', :spell => self.spell, :target => target.name, :gear => "weapon") if !weapon_allowed_specials.include?(weapon_specials_str.downcase)
            end
            #Check that armor specials can be added to weapon
            armor_specials_str = Global.read_config("spells", self.spell, "armor_specials")
            if armor_specials_str
              armor_allowed_specials = FS3Combat.armor_stat(target.armor, "allowed_specials") || []
              return t('custom.cant_cast_on_gear', :spell => self.spell, :target => target.name, :gear => "armor") if !armor_allowed_specials.include?(armor_specials_str)
            end
          end
        else
          return t('custom.dont_know_spell') if (Custom.knows_spell?(caster, self.spell) == false && Custom.item_spell(caster) != spell)
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
        rounds = Global.read_config("spells", self.spell, "rounds")
        heal_points = Global.read_config("spells", self.spell, "heal_points")
        weapon = Global.read_config("spells", self.spell, "weapon")
        fs3_attack = Global.read_config("spells", self.spell, "fs3_attack")
        roll = Global.read_config("spells", self.spell, "roll")
        is_stun = Global.read_config("spells", self.spell, "is_stun")

        if self.caster.combat

          if fs3_attack
            if weapon
              FS3Combat.emit_to_combat caster_combat.combat, t('custom.will_cast_fs3_attack', :name => caster_combat.name, :spell => spell, :target => target_name), nil, true
              FS3Combat.set_weapon(enactor, caster_combat, weapon)
              weapon_type = FS3Combat.weapon_stat(caster_combat.weapon, "weapon_type")
              if is_stun
                FS3Combat.set_action(client, enactor, enactor.combat, caster_combat, FS3Combat::SpellStunAction, self.action_args)
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
          if !caster_combat.is_npc?
            Custom.handle_spell_cast_achievement(self.caster)
          end

        else
          if heal_points
            if Custom.knows_spell?(caster, self.spell)
              Custom.cast_non_combat_heal_with_target(self.caster, self.target, self.spell, self.mod)
              Custom.handle_spell_cast_achievement(self.caster)
            else
              client.emit_failure t('custom.dont_know_spell')
            end
          elsif roll
            if Custom.knows_spell?(caster, self.spell)
              Custom.cast_noncombat_roll_spell_with_target(self.caster, self.target_name, self.spell, self.mod)
              Custom.handle_spell_cast_achievement(self.caster)
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
