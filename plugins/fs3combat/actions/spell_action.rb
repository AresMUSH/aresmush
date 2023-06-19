module AresMUSH
  module FS3Combat
    class SpellAction < CombatAction
      attr_accessor  :spell_name, :target, :names, :has_target, :caster_name

      def prepare
        Global.logger.debug "#{combatant.name.upcase} magic energy beginning of action! #{combatant.associated_model.magic_energy}"
        if (self.action_args =~ /\//)
          self.spell_name = self.action_args.before("/")
          self.names = self.action_args.after("/")
          self.has_target = true
        else
          self.names = combatant.name
          self.spell_name = self.action_args
        end
        self.spell_name = self.spell_name.titlecase
        spell = Global.read_config("spells", self.spell_name)
        error = self.parse_targets(self.names)
        return error if error
        self.caster_name = ExpandedMounts.mounted_names(combatant)

        spell_list = Global.read_config("spells")
        return t('magic.not_spell') if !spell_list.include?(self.spell_name)

        fatigue = Magic.get_fatigue_level(combatant.associated_model)
        return t('magic.fatigue_cant_cast') if fatigue[:degree] == "Total"


        if !combatant.is_npc?
          item_spells = Magic.item_spells(combatant.associated_model) || []
          return t('magic.dont_know_spell') if (Magic.knows_spell?(combatant, self.spell_name) == false && !item_spells.include?(spell))
        end

        return t('magic.more_than_one_round', :spell => self.spell_name) if spell['casting_time'] != "1 round"

        num = spell['target_num']
        return t('magic.doesnt_use_target') if ((num.nil?) && (self.has_target))
        return t('magic.too_many_targets', :spell => self.spell_name, :num => num) if (self.has_target && (self.targets.count > num))

        targets.each do |target|
          return t('magic.dont_target_self') if target == combatant && (spell['fs3_attack'] || spell['is_stun'])
          return t('magic.dont_attack_koed', :target => target.name) if ((spell['fs3_attack'] || spell['is_stun']) && target.is_ko)
          return t('expandedmounts.cast_on_rider') if target.is_mount? && ExpandedMounts.target_rider(spell)
          # Don't let people waste a spell that won't have an effect
          return t('magic.not_dead', :target => target.name) if (spell['is_res'] && !target.associated_model.dead)
          return t('magic.not_ko', :target => target.name) if ((spell['is_revive'] || spell['auto_revive']) && !target.is_ko)
          wound = FS3Combat.worst_treatable_wound(target.associated_model)
          return t('magic.no_healable_wounds', :target => target.name) if (spell['heal_points'] && wound.blank? && !spell['weapon'])
          return t('magic.cannot_spell_fatigue_heal_further', :name => target.name) if (spell['energy_points'] && (target.associated_model.magic_energy >= (target.associated_model.total_magic_energy * 0.8)))
          # Check that weapon specials can be added to weapon
          if spell['weapon_specials']
            # return "This spell is currently broken. Don't worry, I know."
            weapon_special_group = FS3Combat.weapon_stat(target.weapon, "special_group") || ""
            weapon_allowed_specials = Global.read_config("fs3combat", "weapon special groups", weapon_special_group) || []
            return t('magic.cant_cast_on_gear', :spell => self.spell_name, :target => target.name, :gear => "#{target.weapon} weapon") if !weapon_allowed_specials.include?(spell['weapon_specials'].downcase)
          end
          #Check that armor specials can be added to weapon

          if spell['armor_specials']
            # return "This spell is currently broken. Don't worry, I know."
            armor_special_group = FS3Combat.armor_stat(target.armor, "special_group") || ""
            armor_allowed_specials = Global.read_config("fs3combat", "armor special groups", armor_special_group) || []
            puts "Target: #{target.armor} #{armor_special_group} ALLOWED: #{armor_allowed_specials}"
            return t('magic.cant_cast_on_gear', :spell => self.spell_name, :target => target.name, :gear => "#{target.armor} armor") if !armor_allowed_specials.include?(spell['armor_specials'].downcase)
          end

        end

        return nil
      end

      def print_action

        if self.has_target
          msg = t('magic.spell_target_action_msg_long', :name => self.caster_name, :spell => self.spell_name, :target => print_target_names)
          msg
        else
          msg = t('magic.spell_action_msg_long', :name => self.caster_name, :spell => self.spell_name)
          msg
        end
      end

      def print_action_short
        t('magic.spell_target_action_msg_short', :target => print_target_names)
      end

      def resolve
        spell = Global.read_config("spells", self.spell_name)
        messages = []
        combatant.log "~* #{self.combatant.name.upcase} CASTING #{self.spell_name.upcase} *~"

        succeeds = Magic.roll_combat_spell(combatant, self.spell_name)
        if (spell['auto_revive'] && targets.include?(self.combatant))
          succeeds = {:succeeds=>"%xgSUCCEEDS%xn", :result=>5}
        end

        # roll_combat_spell_success handles combat mods via roll_combat_spell

        #Spells roll for success individually because they can only do one thing. This is because attacks need to use different measures of success. Also, because weapon changes for FS3 attacks are on the caster, not the target.

        if (spell['fs3_attack'] || spell['is_stun'])

          if succeeds[:succeeds] == "%xgSUCCEEDS%xn"
            #Weapon
            if (spell['weapon'] && spell['weapon'] != "Spell")
              FS3Combat.set_weapon(combatant, combatant, spell['weapon'])
            end

            weapon_type = FS3Combat.weapon_stat(self.combatant.weapon, "weapon_type")
            targets.each do |target|
              if spell['is_stun']
                message = Magic.cast_stun(self.caster_name, self.combatant, target, self.spell_name, spell['rounds'], result = succeeds[:result])
                messages.concat message
              elsif weapon_type == "Explosive"
                message = Magic.cast_explosion(self.caster_name, self.combatant, target, self.spell_name, result = succeeds[:result])
                messages.concat message
              elsif weapon_type == "Suppressive"
                message = Magic.cast_suppress(self.caster_name, self.combatant, target, self.spell_name, succeeds[:result])
                messages.concat message
              else
                message = Magic.cast_attack_target(self.caster_name, self.combatant, target, result = succeeds[:result])
                messages.concat message
              end
            end
          else
            messages.concat [t('magic.spell_target_resolution_msg', :name =>  combatant.name, :spell => self.spell_name, :target => print_target_names, :succeeds => "%xrFAILS%xn")]
          end
        else

          #Spell effects here do not roll for success individually because a spell may do more than one thing and so need one success roll.
          if succeeds[:succeeds] == "%xgSUCCEEDS%xn"
            targets.each do |target|

              #Shields
              if spell['is_shield'] == true
                message = Magic.cast_shield(self.caster_name, target, self.spell_name, spell['rounds'], succeeds[:result])
                messages.concat message
              end

              #Healing, Reviving, and Resurrecting
              if spell['heal_points']
                message = Magic.cast_heal(self.caster_name, target, self.spell_name, spell['heal_points'])
                messages.concat message
              end

              if spell['energy_points']
                Global.logger.debug "Magic energy before heal method: #{target.associated_model }#{target.associated_model.name} #{target.associated_model.magic_energy}"
                message = Magic.cast_fatigue_heal(self.caster_name, target.associated_model, self.spell_name)
                if combatant == target
                  combatant.associated_model.update(magic_energy: target.associated_model.magic_energy)
                end
                messages.concat message
                Global.logger.debug "Magic energy after heal method!: #{target.associated_model }#{target.associated_model.name} #{target.associated_model.magic_energy}"
              end

              if spell['is_revive']
                message = Magic.cast_revive(self.caster_name, combatant, target, self.spell_name)
                messages.concat message
              end

              if spell['auto_revive']
                message = Magic.cast_auto_revive(combatant, target, self.spell_name)
                messages.concat message
              end

              if spell['is_res']
                message = Magic.cast_resurrection(self.caster_name, combatant, target, self.spell_name)
                messages.concat message
              end

              #Weapons & Weapon specials
              if (spell['weapon'] && spell['weapon'] != "Spell" && !target.is_mount?)
                message = Magic.cast_weapon(self.caster_name, combatant, target, self.spell_name, spell['weapon'])
                messages.concat message
              end

              if spell['weapon_specials']
                message = Magic.cast_weapon_specials(self.caster_name, combatant, target, self.spell_name)
                messages.concat message
              end

              #Armor & Armor Specials
              if spell['armor']
                message = Magic.cast_armor(self.caster_name, combatant, target, self.spell_name, spell['armor'])
                messages.concat message
              end

              if spell['armor_specials']
                message = Magic.cast_armor_specials(self.caster_name, combatant, target, self.spell_name)
                messages.concat message
              end

              #Inflict Damage
              if spell['damage_inflicted']
                is_mock = !combat.is_real?
                message = Magic.cast_inflict_damage(self.caster_name, combatant, target, self.spell_name, spell['damage_inflicted'], spell['damage_desc'], is_mock)
                messages.concat message
              end

              #Apply Mods
              if spell['attack_mod'] || spell['defense_mod'] || spell['init_mod'] || spell['lethal_mod'] || spell['spell_mod']
                message = Magic.cast_mod(self.caster_name, combatant, target, self.spell_name, spell['damage_type'], spell['rounds'], succeeds[:result], spell['attack_mod'], spell['defense_mod'], spell['init_mod'], spell['lethal_mod'], spell['spell_mod'])
                messages.concat message
              end

              #Roll
              if spell['roll']
                message = Magic.cast_combat_roll(self.caster_name, combatant, target, self.spell_name, spell['damage_type'], succeeds[:result])
                messages.concat message
              end
            #End targets.each do for non FS3 attack spells (if spell succeeds)
            end

          #Spell fails
          elsif !target
            messages.concat [t('magic.spell_resolution_msg', :name => self.caster_name, :spell => self.spell_name, :mod => "", :succeeds => "%xrFAILS%xn")]
          else
            messages.concat [t('magic.spell_target_resolution_msg', :name =>  self.caster_name, :spell => self.spell_name, :target => print_target_names, :succeeds => "%xrFAILS%xn")]
          #End spell rolls
          end
        end
        start_fatigue = Magic.get_fatigue_level(combatant.associated_model)[:degree]
        Magic.subtract_magic_energy(combatant.associated_model, self.spell_name, succeeds[:succeeds])
        final_fatigue = Magic.get_fatigue_level(combatant.associated_model)[:degree]
        serious_degrees = ["Severe", "Extreme", "Total"]

        if start_fatigue != final_fatigue || serious_degrees.include?(final_fatigue)
          messages.concat [Magic.get_fatigue_level(combatant.associated_model)[:msg]]
        end
        Global.logger.debug "Combatant energy end of action: #{combatant.associated_model.magic_energy}"
        level = Global.read_config("spells", self.spell_name, "level")
        # if level == 8
        #   messages.concat [t('magic.level_eight_fatigue', :name => self.name)]
        # end
        messages
      end
    end
  end
end


