module AresMUSH
  module Magic

    def self.shields
      Global.read_config("spells").select { |spell| Global.read_config("spells", spell, "shields_against")}.map {|name, data| name}
    end

    def self.shield_types
      Global.read_config("spells").select { |spell| Global.read_config("spells", spell, "shields_against")}.map {|name, data| data['shields_against']}.uniq
    end

    def self.find_shield_named(char, shield_name)
      shield_name = shield_name.titlecase
      char.magic_shields.select { |shield| shield.name == shield_name }.first
    end

    def self.find_best_shield(char_or_combatant, damage_type)
      if (char_or_combatant.class == Combatant)
        char = char_or_combatant.associated_model
      else
        char = char_or_combatant
      end
      shields = char.magic_shields.select { |shield| shield.shields_against == damage_type}
      best_shield = shields.max_by { |s| s.strength}

      if best_shield
        return best_shield
      end
    end

    def self.shield_newturn_countdown(combatant)
      shields = combatant.associated_model.magic_shields

      shields.each do |shield|
        if shield.strength > 0 && shield.rounds == 0
          FS3Combat.emit_to_combat combatant.combat, t('magic.shield_wore_off', :name => combatant.name, :shield => shield[:name]), nil, true
          shield.update(strength: 0)
        else
          shield.update(rounds: shield.rounds - 1)
        end
      end
    end

    def self.stopped_by_shield?(target, char_or_combatant, spell, result)
      damage_type = Global.read_config("spells", spell, "damage_type")
      school = Global.read_config("spells", spell, "school")
      shield = Magic.find_best_shield(target, damage_type)
      if shield
        successes = result

        if (char_or_combatant.class == Combatant)
          caster_name = char_or_combatant.associated_model.name
          char_or_combatant.log "#{shield.name.upcase}: #{caster_name}'s #{school} (#{successes} successes) vs #{target.name}'s #{shield.name} (strength #{shield.strength})."
        else
          caster_name = Character.named(char_or_combatant).name
          Global.logger.info "#{shield.name.upcase}: #{caster_name}'s #{school} (#{successes} successes) vs #{target.name}'s #{shield.name} (strength #{shield.strength})."
        end

        delta = shield.strength - successes
        case delta
        when 0..99
          winner = "shield"
        when -99..-1
          winner = "caster"
        end

        if winner == "shield"
          return {
          msg: t('magic.shield_held', :name => caster_name, :spell => spell, :mod => "", :shield => shield.name, :target => target.name),
          shield: shield.name,
          hit: false
          }
        else
          return {
          msg: t('magic.shield_failed', :name => caster_name, :spell => spell, :mod => "", :shield => shield.name, :target => target.name),
          shield: shield.name,
          hit: true
          }
        end
      end
      #There is no shield protecting against the damage type.
    end

    def self.shield_mods(target, damage_type)
      shield = Magic.find_best_shield(target, damage_type)
      shield_mod = (-20 - (shield.strength * 5))
      target.log "Shield modifiers: #{shield_mod}"
      return shield_mod
    end



  end
end
