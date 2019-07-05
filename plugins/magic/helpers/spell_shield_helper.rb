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

    def self.roll_shield(target, caster, spell)
      damage_type = Global.read_config("spells", spell, "damage_type")
      effect = Global.read_config("spells", spell, "effect")
      school = Global.read_config("spells", spell, "school")
      Global.logger.debug "Effect: #{effect}"
      Global.logger.debug "Fire: #{target.endure_fire}"
      Global.logger.debug "Mind: #{target.endure_fire}"
      Global.logger.debug "Cold: #{target.endure_fire}"

      if damage_type == "Fire"
        shield_strength = target.endure_fire
        shield = "Endure Fire"
      elsif damage_type == "Cold"
        shield_strength = target.endure_cold
        shield = "Endure Cold"
      elsif effect == "Psionic"
        shield_strength = target.mind_shield
        shield = "Mind Shield"
      else
        shield_strength = 0
        shield = "None"
      end

      if caster.combat
        successes = caster.roll_ability(school)
      else
        successes = caster.roll_ability(school)[:successes]
      end

      delta = shield_strength - successes

      if caster.combat
        caster.log "#{shield.upcase}: #{caster.name} rolling #{school} vs #{target.name}'s #{shield} (strength #{shield_strength}): #{successes} successes."
      else
        Global.logger.info "#{shield.upcase}: #{caster.name} rolling #{school} vs #{target.name}'s #{shield} (strength #{shield_strength}): #{successes} successes."
      end

      # if (shield_strength <=0 && successes <= 0)
      #   return "shield"
      # else
      #   return "failed"
      # end

      case delta
      when 0..99
        return "shield"
      when -99..-1
        return "caster"
      end

    end

  end
end
