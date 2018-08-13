module AresMUSH
  module Spells
    class SpellCastCmd
    #spell/cast <spell>
      include CommandHandler
      attr_accessor :name, :weapon_name, :spell, :spell_list, :weapon,  :weapon_type

      def parse_args
       self.spell = titlecase_arg(cmd.args)
       self.spell_list = Global.read_config("spells")
      end

      def check_errors
        require_target = Global.read_config("spells", self.spell, "require_target")
        return t('Spells.not_spell') if !self.spell_list.include?(self.spell)
        # return t('Spells.already_cast') if Spells.already_cast(enactor)
        return t('Spells.needs_target') if require_target
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
        caster = enactor



        if enactor.combatant
          if enactor.combatant.is_ko
            client.emit_failure t('Spells.spell_ko')
          else
            #Roll for success
            succeeds = Spells.roll_spell_success(caster, self.spell)
            client.emit "#{succeeds}"

            #Roll Spell in Combat
            if roll == true
              Spells.cast_roll_spell(caster, self.spell)
            end

            #Equip Weapon
            if weapon
              Spells.cast_equip_weapon(caster, self.spell)
            end

            #Equip Weapon Specials
            if weapon_specials
              if succeeds == "%xgSUCCEEDS%xn"
                caster.combatant.update(weapon_specials: specials ? specials.map { |s| s.titlecase } : [])
                FS3Combat.emit_to_combat enactor.combat, t('Spells.casts_spell', :name => enactor.name, :spell => self.spell)
              else
                FS3Combat.emit_to_combat enactor.combat, t('Spells.casts_spell', :name => enactor.name, :spell => spell, :succeeds => succeeds)
              end
              FS3Combat.set_action(client, enactor, enactor.combat, enactor.combatant, FS3Combat::SpellAction, "")
            end

            #Equip Armor
            if armor
              Spells.cast_equip_armor(caster, self.spell)
            end

            #Equip Armor Specials
            if armor_specials
              Spells.cast_equip_armor_specials(caster, self.spell)
            end

            #Stun
            if is_stun
              Spells.cast_stun_spell(caster, self.spell)
            end
            FS3Combat.set_action(client, enactor, enactor.combat, enactor.combatant, FS3Combat::SpellAction, "")
          end
        enactor.update(has_cast: true)
        elsif
          #Roll NonCombat
          if roll
            Rooms.emit_to_room(enactor.room, t('Spells.casts_noncombat_spell', :name => enactor.name, :spell => self.spell))
            die_result = FS3Skills.parse_and_roll(client, enactor, school)
              success_level = FS3Skills.get_success_level(die_result)
              success_title = FS3Skills.get_success_title(success_level)
              message = t('fs3skills.simple_roll_result',
                :name => enactor.name,
                :roll => school,
                :dice => FS3Skills.print_dice(die_result),
                :success => success_title
              )
              FS3Skills.emit_results message, client, enactor_room, false
          else
            client.emit_failure t('Spells.not_in_combat')
          end

        end


      end

    end
  end
end
