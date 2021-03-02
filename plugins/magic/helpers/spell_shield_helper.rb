module AresMUSH
  module Magic

    def self.spell_shields
      ["Mind Shield", "Endure Fire", "Endure Cold", "Group Endure Cold", "Enduring Mind Shield", "Group Endure Fire"]
    end

    def self.shields_expire (char)
      room = char.room
      if (char.mind_shield > 0)
        room.emit_ooc t('magic.shield_wore_off', :name => char.name, :shield => "Mind Shield")
        char.update(mind_shield: 0)
      end

      if (char.endure_fire > 0)
        room.emit_ooc t('magic.shield_wore_off', :name => char.name, :shield => "Endure Fire")
        char.update(endure_fire: 0)
      end

      if (char.endure_cold > 0)
        room.emit_ooc t('magic.shield_wore_off', :name => char.name, :shield => "Endure Cold")
        char.update(endure_cold: 0)
      end
    end

    def self.apply_out_of_combat_shields(char, combatant)
      combatant.update(mind_shield: char.mind_shield)
      combatant.update(mind_shield_counter: 10)
      combatant.update(endure_fire: char.endure_fire)
      combatant.update(endure_fire_counter: 10)
      combatant.update(endure_cold: char.endure_cold)
      combatant.update(endure_cold_counter: 10)
    end

    def self.check_spell_vs_shields(target, caster_name, spell, mod, result)
      damage_type = Global.read_config("spells", spell, "damage_type")

      if Character.named(caster_name)
        caster = Character.named(caster_name)
        caster_name = caster.name
        held = Magic.check_shield(target, caster_name, spell, result) == "shield"
      else
        caster = caster_name
        held = Magic.check_shield(target, caster_name, spell, result) == "shield"
      end

      if (damage_type == "Psionic" && target.mind_shield > 0)
        if held
          message = t('magic.shield_held', :name => caster_name, :spell => spell, :mod => mod, :target => target.name, :shield => "Mind Shield")
        else
          message = t('magic.mind_shield_failed', :name => caster_name, :spell =>  spell, :mod => mod, :target => target.name, :shield => "Mind Shield")
        end
      elsif (damage_type == "Fire" && target.endure_fire > 0)
        if held
          message = t('magic.shield_held', :name => caster_name, :spell => spell, :mod => mod, :target => target.name, :shield => "Endure Fire")
        else
          message = t('magic.shield_failed', :name =>caster_name, :spell => spell, :mod => mod, :target => target.name, :shield => "Endure Fire")
        end
      elsif (damage_type == "Cold" && target.endure_cold > 0)
        if held
          message = t('magic.shield_held', :name => caster_name, :spell => spell, :mod => mod, :target => target.name, :shield => "Endure Cold")
        else
          message = t('magic.shield_failed', :name => caster_name, :spell => spell, :mod => mod, :target => target.name, :shield => "Endure Cold")
        end
      else
        message = nil
      end
      return message
    end

    def self.stopped_by_shield?(spell, target, combatant, result)
      # ignore = ["Stun (Air)", "Stun (Corpus)", "Stun (Earth)", "Stun (Fire)", "Stun (Nature)", "Stun (Water)", "Stun (Will)", "Spell"]
      #
      # if ignore.include?(combatant.weapon)
      #   return nil
      if ((target.mind_shield > 0 || target.endure_fire > 0 || target.endure_cold > 0 ) && Magic.is_magic_weapon(combatant.weapon))


        damage_type = Global.read_config("spells", spell, "damage_type")
        roll_shield = Magic.check_shield(target, combatant.name, spell, result)
        if roll_shield == "shield"
          if (damage_type == "Fire" && target.endure_fire > 0)
            return {
            msg: t('custom.shield_held', :name => combatant.name, :spell => combatant.weapon, :mod => "", :shield => "Endure Fire", :target => target.name),
            hit: false
            }
          elsif (damage_type == "Cold" && target.endure_cold > 0)
            return  {
            msg: t('custom.shield_held', :name => combatant.name, :spell => combatant.weapon, :mod => "", :shield => "Endure Cold", :target => target.name),
            hit: false
            }
          elsif (damage_type == "Psionic" && target.mind_shield > 0)
            return {
            msg: t('custom.shield_held', :name => combatant.name, :spell => combatant.weapon, :mod => "", :shield => "Mind Shield", :target => target.name),
            hit: false
            }
          end

        elsif roll_shield == "caster"
          if (damage_type == "Fire" && target.endure_fire > 0)
            return {
            msg: t('custom.shield_failed', :name => combatant.name, :spell => combatant.weapon, :mod => "", :shield => "Endure Fire", :target => target.name),
            hit: true
            }
          elsif (damage_type == "Cold" && target.endure_cold > 0)
            return {
            msg: t('custom.shield_failed', :name => combatant.name, :spell => combatant.weapon, :mod => "", :shield => "Endure Cold", :target => target.name),
            hit: true
            }
          elsif (damage_type == "Psionic" && target.mind_shield > 0)
            return {
            msg: t('custom.shield_failed', :name => combatant.name, :spell => combatant.weapon, :mod => "", :shield => "Mind Shield", :target => target.name),
            hit: true
            }
          end
        else
          return false
        end
      else
        return nil
      end
    end

    # def self.stopped_by_shield_msg(combatant, target, stopped_by_shield)
    #   if stopped_by_shield == "Endure Fire Held"
    #     message = t('custom.shield_held', :name => combatant.name, :spell => combatant.weapon, :mod => "", :shield => "Endure Fire", :target => target.name)
    #   elsif stopped_by_shield == "Endure Cold Held"
    #     message = t('custom.shield_held', :name => combatant.name, :spell => combatant.weapon, :mod => "", :shield => "Endure Cold", :target => target.name)
    #   elsif stopped_by_shield == "Mind Shield Held"
    #     message = t('custom.shield_held', :name => combatant.name, :spell => combatant.weapon, :mod => "", :shield => "Mind Shield", :target => target.name)
    #   end
    # end

    def self.check_shield(target, caster_name, spell, result)
      damage_type = Global.read_config("spells", spell, "damage_type")
      school = Global.read_config("spells", spell, "school")

      if Character.named(caster_name)
        caster = Character.named(caster_name)
        caster_name = caster.name
        if caster.combat
          in_combat = true
        end
      else
        caster = caster_name
      end

      if damage_type == "Fire"
        shield_strength = target.endure_fire
        shield = "Endure Fire"
      elsif damage_type == "Cold"
        shield_strength = target.endure_cold
        shield = "Endure Cold"
      elsif damage_type == "Psionic"
        shield_strength = target.mind_shield
        shield = "Mind Shield"
      else
        shield_strength = 0
        shield = "None"
      end

      successes = result
      delta = shield_strength - successes

      if in_combat
        caster.combatant.log "#{shield.upcase}: #{caster_name}'s #{school} (#{successes} successes) vs #{target.name}'s #{shield} (strength #{shield_strength})."
      else
        Global.logger.info "#{shield.upcase}: #{caster_name}'s #{school} (#{successes} successes) vs #{target.name}'s #{shield} (strength #{shield_strength})."
      end

      case delta
      when 0..99
        return "shield"
      when -99..-1
        return "caster"
      end
    end

    def self.spell_damage_type(weapon)
      if weapon == "Cold Shrapnel"
        damage_type = "Cold"
      elsif weapon == "Fire Shrapnel"
        damage_type = "Fire"
      else
        damage_type = Global.read_config("spells", weapon, "damage_type")
      end
      return damage_type
    end

    def self.shield_failed_msgs(target, damage_type, weapon, attack_name)
      messages = []
      if (damage_type == "Fire" && target.endure_fire > 0)
        if weapon == "Fire Shrapnel"
          messages.concat [t('magic.shrapnel_shield_failed', :name => attack_name, :weapon => weapon, :mod => "", :shield => "Endure Fire", :target => target.name)]
        else
          messages.concat [t('magic.shield_failed', :name => attack_name, :spell => weapon, :mod => "", :shield => "Endure Fire", :target => target.name)]
        end
      elsif (damage_type == "Cold" && target.endure_cold > 0)
        if weapon == "Cold Shrapnel"
          messages.concat [t('magic.shrapnel_shield_failed', :name => attack_name, :weapon => weapon, :mod => "", :shield => "Endure Cold", :target => target.name)]
        else
          messages.concat [t('magic.shield_failed', :name => attack_name, :spell => weapon, :mod => "", :shield => "Endure Cold", :target => target.name)]
        end
      end
    end

    def self.shield_mods(target, damage_type)
      if (damage_type == "Fire" && target.endure_fire > 0)
        math = target.endure_fire * 5
        endure_fire_mod = -20 - math
        endure_cold_mod = 0
      elsif (damage_type == "Cold" && target.endure_cold > 0)
        math = target.endure_cold * 5
        endure_cold_mod = -20 - math
        endure_fire_mod = 0
      else
        endure_cold_mod = 0
        endure_fire_mod = 0
      end
      target.log "Shield modifiers: endure_fire=#{endure_fire_mod} endure_cold=#{endure_cold_mod}"
      return endure_fire_mod + endure_cold_mod
    end

    def self.shield_newturn_countdown(combatant)
      if (combatant.mind_shield_counter == 0 && combatant.mind_shield > 0)
        FS3Combat.emit_to_combat combatant.combat, t('custom.shield_wore_off', :name => combatant.name, :shield => "Mind Shield"), nil, true
        combatant.update(mind_shield: 0)
        combatant.log "#{combatant.name} no longer has a Mind Shield."
      elsif (combatant.mind_shield_counter > 0 && combatant.mind_shield > 0)
        combatant.update(mind_shield_counter: combatant.mind_shield_counter - 1)
      end

      if (combatant.endure_fire_counter == 0 && combatant.endure_fire > 0)
        FS3Combat.emit_to_combat combatant.combat, t('custom.shield_wore_off', :name => combatant.name, :shield => "Endure Fire"), nil, true
        combatant.update(endure_fire: 0)
        combatant.log "#{combatant.name} can no longer Endure Fire."
      elsif (combatant.endure_fire_counter > 0 && combatant.endure_fire > 0)
        combatant.update(endure_fire_counter: combatant.endure_fire_counter - 1)
      end

      if (combatant.endure_cold_counter == 0 && combatant.endure_cold > 0)
        FS3Combat.emit_to_combat combatant.combat, t('custom.shield_wore_off', :name => combatant.name, :shield => "Endure Cold"), nil, true
        combatant.update(endure_cold: 0)
        combatant.log "#{combatant.name} can no longer Endure Cold."
      elsif (combatant.endure_cold_counter > 0 && combatant.endure_cold > 0)
        combatant.update(endure_cold_counter: combatant.endure_cold_counter - 1)
      end
    end

  end
end
