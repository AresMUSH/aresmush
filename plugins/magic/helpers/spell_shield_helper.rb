module AresMUSH
  module Magic

    def self.spell_shields
      ["Mind Shield", "Endure Fire", "Endure Cold"]
    end

    def self.shields_expire (char)
      room = char.room
      if (char.mind_shield > 0)
        room.emit_ooc t('magic.shield_wore_off', :name => char.name, :shield => "Mind Shield")
      end

      if (char.endure_fire > 0)
        room.emit_ooc t('magic.shield_wore_off', :name => char.name, :shield => "Endure Fire")
      end

      if (char.endure_cold > 0)
        room.emit_ooc t('magic.shield_wore_off', :name => char.name, :shield => "Endure Cold")
      end
        char.update(mind_shield: 0)
        char.update(endure_fire: 0)
        char.update(endure_cold: 0)
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
            return "Endure Fire Held"
          elsif (damage_type == "Cold" && target.endure_cold > 0)
            return "Endure Cold Held"
          elsif (damage_type == "Psionic" && target.mind_shield > 0)
            return "Mind Shield Held"
          end

        elsif roll_shield == "caster"
          if (damage_type == "Fire" && target.endure_fire > 0)
            return "Endure Fire Failed"
          elsif (damage_type == "Cold" && target.endure_cold > 0)
            return "Endure Cold Failed"
          elsif (damage_type == "Psionic" && target.mind_shield > 0)
            return "Mind Shield Failed"
          end
        else
          return false
        end
      else
        return nil
      end
    end

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

  end
end
