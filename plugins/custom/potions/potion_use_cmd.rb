module AresMUSH
  module Custom
    class PotionUseCmd
    #potion/use <potion>
      include CommandHandler
      attr_accessor :potion, :potion_name, :spell, :roll

      def parse_args
        self.potion_name = titlecase_arg(cmd.args)
        self.spell = titlecase_arg(cmd.args)
        self.potion = Custom.find_potion_has(enactor, self.potion_name)
      end

      def check_errors
        return t('custom.dont_have_potion') if !Custom.find_potion_has(enactor, self.potion_name)
        return t('custom.already_cast') if Custom.already_cast(enactor)
        return nil
      end

      def handle
      #Reading Config
        require_target = Global.read_config("spells", self.spell, "require_target")
        weapon = Global.read_config("spells", self.spell, "weapon")
        weapon_specials = Global.read_config("spells", self.spell, "weapon_specials")
        armor = Global.read_config("spells", self.spell, "armor")
        armor_specials = Global.read_config("spells", self.spell, "self.armor_specials")
        is_stun = Global.read_config("spells", self.spell, "is_stun")
        roll = Global.read_config("spells", self.spell, "roll")
        school = Global.read_config("spells", self.spell, "school")
        spell_mod = Global.read_config("spells", self.spell, "spell_mod")
        heal_points = Global.read_config("spells", self.spell, "heal_points")
        stance = Global.read_config("spells", self.spell, "stance")
        lethal_mod = Global.read_config("spells", self.spell, "lethal_mod")
        attack_mod = Global.read_config("spells", self.spell, "attack_mod")
        defense_mod = Global.read_config("spells", self.spell, "defense_mod")
        spell_mod = Global.read_config("spells", self.spell, "spell_mod")
        #NonCombat Potions
        if !enactor.combat
          if roll
            #Roll things
            Rooms.emit_to_room(enactor.room, t('custom.use_potion', :name => enactor.name, :potion => self.potion_name))
            if spell_mod
              roll_str = "#{school} + #{enactor.combatant.spell_mod}"
            else
              roll_str = "#{school}"
            end
              die_result = FS3Skills.parse_and_roll(client, enactor, roll_str)
              success_level = FS3Skills.get_success_level(die_result)
              success_title = FS3Skills.get_success_title(success_level)
              message = t('fs3skills.simple_roll_result',
                :name => enactor.name,
                :roll => roll,
                :dice => FS3Skills.print_dice(die_result),
                :success => success_title
              )
              FS3Skills.emit_results message, client, enactor_room, false

          else
            client.emit_failure t('custom.potion_not_in_combat')
          end
        end
        #Combat Potions
        if enactor.combat
          if enactor.combatant.is_ko
            client.emit_failure t('custom.potion_ko')
          else
            if roll
              #Roll things
              FS3Combat.emit_to_combat enactor.combat, t('custom.use_potion', :name => enactor.name, :potion => self.potion_name)
              if spell_mod
                roll_str = "#{roll} + #{enactor.combatant.spell_mod}"
              else
                roll_str = "#{roll}"
              end
              die_result = FS3Skills.parse_and_roll(client, enactor, roll_str)
              success_level = FS3Skills.get_success_level(die_result)
              success_title = FS3Skills.get_success_title(success_level)
              message = t('fs3skills.simple_roll_result',
                :name => enactor.name,
                :roll => roll,
                :dice => FS3Skills.print_dice(die_result),
                :success => success_title
              )
              FS3Skills.emit_results message, client, enactor_room, false
              FS3Combat.set_action(client, enactor, enactor.combat, enactor.combatant, FS3Combat::PotionAction, "")
            end

            if heal_points
              #Healing
              wound = FS3Combat.worst_treatable_wound(enactor)
              if (wound)
                FS3Combat.heal(wound, heal_points)
                FS3Combat.emit_to_combat enactor.combat, t('custom.potion_heal', :name => enactor.name, :potion => self.potion_name, :points => heal_points)
                FS3Combat.set_action(client, enactor, enactor.combat, enactor.combatant, FS3Combat::PotionAction, "")
              else
                FS3Combat.emit_to_combat enactor.combat, t('custom.potion_heal_no_effect', :name => enactor.name, :potion => self.potion_name)
                FS3Combat.set_action(client, enactor, enactor.combat, enactor.combatant, FS3Combat::PotionAction, "")
              end
            end

            if stance
            #Update stance
              enactor.combatant.update(stance: stance)
              FS3Combat.emit_to_combat enactor.combat, t('custom.potion_stance', :name => enactor.name, :potion => self.potion_name, :stance => stance)
              FS3Combat.set_action(client, enactor, enactor.combat, enactor.combatant, FS3Combat::PotionAction, "")
            end

            if weapon
            #Equip weapon
              enactor.combatant.update(weapon_name: weapon)
              weapon_type = FS3Combat.weapon_stat(enactor.combatant.weapon, "weapon_type")
              if armor

              elsif is_stun

              elsif weapon_type == "Explosive"
                FS3Combat.emit_to_combat enactor.combat, t('custom.use_potion', :name => enactor.name, :spell => self.spell)
                FS3Combat.emit_to_combatant enactor.combatant, t('custom.target_aoe')
              elsif weapon_type == "Supressive"
                FS3Combat.emit_to_combat enactor.combat, t('custom.use_potion', :name => enactor.name, :spell => self.spell)
                FS3Combat.emit_to_combatant enactor.combatant, t('custom.target_suppress')
              else
                FS3Combat.emit_to_combat enactor.combat, t('custom.use_potion', :name => enactor.name, :spell => self.spell)
                FS3Combat.emit_to_combatant enactor.combatant, t('custom.target_attack')
              end
              FS3Combat.emit_to_combat enactor.combat, t('custom.use_potion', :name => enactor.name, :potion => self.potion_name)
              FS3Combat.emit_to_combatant enactor.combatant, t('custom.target_attack')
            end

            if weapon_specials
            #Equip Weapon Specials
              enactor.combatant.update(weapon_specials: weapon_specials)
              FS3Combat.emit_to_combat enactor.combat, t('custom.use_potion', :name => enactor.name, :potion => self.potion_name)
              FS3Combat.set_action(client, enactor, enactor.combat, enactor.combatant, FS3Combat::PotionAction, "")
            end

            if armor
            #Equip Armor
              enactor.combatant.update(armor_name: armor)
              FS3Combat.emit_to_combat enactor.combat, t('custom.use_potion', :name => enactor.name, :potion => self.potion_name)
              FS3Combat.set_action(client, enactor, enactor.combat, enactor.combatant, FS3Combat::PotionAction, "")
            end

            if defense_mod
            #Set defense mods
              current_mod = enactor.combatant.defense_mod
              new_mod = current_mod + defense_mod
              enactor.combatant.update(defense_mod: new_mod)
              FS3Combat.emit_to_combat enactor.combat, t('custom.potion_mod', :name => enactor.name, :potion => self.potion_name, :mod => defense_mod, :type => "defense", :total_mod => enactor.combatant.defense_mod)
              FS3Combat.set_action(client, enactor, enactor.combat, enactor.combatant, FS3Combat::PotionAction, "")
            end

            if attack_mod
            #Set attack mods
              target = enactor
              current_mod = target.combatant.attack_mod
              new_mod = current_mod + attack_mod
              target.combatant.update(attack_mod: new_mod)
              FS3Combat.emit_to_combat enactor.combat, t('custom.potion_mod', :name => enactor.name, :target => target.name, :potion => self.potion_name, :mod => attack_mod, :type => "attack", :total_mod => target.combatant.attack_mod)
              FS3Combat.set_action(client, enactor, enactor.combat, enactor.combatant, FS3Combat::PotionAction, "")
            end

            if spell_mod
            #Set spell mods
              target = enactor
              current_mod = target.combatant.spell_mod.to_i
              new_mod = current_mod + spell_mod
              target.combatant.update(spell_mod: new_mod)
              FS3Combat.emit_to_combat enactor.combat, t('custom.potion_mod', :name => enactor.name, :potion => self.potion_name, :mod => spell_mod, :type => "spell", :total_mod => target.combatant.spell_mod)
              FS3Combat.set_action(client, enactor, enactor.combat, enactor.combatant, FS3Combat::PotionAction, "")
            end

          enactor.combatant.update(has_cast: true)
          end
        end
        self.potion.delete

      end







    end
  end
end
