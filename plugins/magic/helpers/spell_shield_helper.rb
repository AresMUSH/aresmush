module AresMUSH
  module Magic

    # def self.shields
    #   Global.read_config("spells").select { |spell| Global.read_config("spells", spell, "shields_against")}.map {|name, data| name}
    # end

    # def self.shield_types
    #   Global.read_config("spells").select { |spell| Global.read_config("spells", spell, "shields_against")}.map {|name, data| data['shields_against']}.uniq
    # end

    def self.find_shield_named(char, shield_name)
      shield_name = shield_name.titlecase
      char.magic_shields.select { |shield| shield.name == shield_name }.first
    end

    def self.find_best_shield(char_or_combatant, damage_type)
      char = Magic.get_associated_model(char_or_combatant)
      shields = []
      exceptions = Global.read_config("magic", "shields_against_all_exceptions")
      if !exceptions.include?(damage_type)
        shields.concat char.magic_shields.select { |shield| shield.shields_against == "All" }
      end
      shields_against_type = char.magic_shields.select { |shield| shield.shields_against == damage_type}
      shields = shields.concat shields_against_type
      best_shield = shields.max_by { |s| s.strength}
      if best_shield
        return best_shield
      else
        return false
      end
    end

    def self.shield_newturn_countdown(combatant)
      shields = combatant.associated_model.magic_shields
      puts "Shields: #{shields.to_a}"
      shields.each do |shield|
        puts "Rounds: #{shield.name} #{shield.rounds}"
        if shield.rounds == 0
          FS3Combat.emit_to_combat combatant.combat, t('magic.shield_wore_off', :name => combatant.name, :shield => shield.name), nil, true
          shield.delete
          puts ""
        else
          shield.update(rounds: shield.rounds - 1)
        end
      end
    end

    def self.determine_margin_with_shield(target, combatant, weapon_or_spell, attack_roll, defense_roll)
      
      stopped_by_shield = Magic.stopped_by_shield?(target, combatant.name, combatant.weapon, attack_roll)
      if stopped_by_shield
        is_stun = Global.read_config("spells", weapon_or_spell, "is_stun") || FS3Combat.weapon_stat(weapon_or_spell, "is_stun") || false
        if stopped_by_shield[:hit] && is_stun
          attacker_net_successes = attack_roll - defense_roll
          hit = attacker_net_successes > 0
        else 
          hit = stopped_by_shield[:hit]
        end
        return {
          hit: hit,
          message: stopped_by_shield[:msg],
          shield: stopped_by_shield[:shield],
          # shield_held: stopped_by_shield[:shield_held]
        }
      end
      #There is no shield in effect
    end

    def self.stopped_by_shield?(target_char_or_combatant, caster_name, weapon_or_spell, result)
      target = Magic.get_associated_model(target_char_or_combatant)
      damage_type = Magic.magic_damage_type(weapon_or_spell)
      shield = Magic.find_best_shield(target, damage_type)
      puts "All shields: #{target.magic_shields.to_a}"
      if shield
        roll_name = FS3Combat.weapon_stat(weapon_or_spell, "skill") || Global.read_config("spells", weapon_or_spell, "school")
        
        delta = shield.strength - result
        case delta
        when 0..99
          winner = "shield"
        when -99..-1
          winner = "caster"
        end

        log_msg = "#{shield.name.upcase}: #{caster_name}'s #{roll_name} (#{result} successes) vs #{target.name}'s #{shield.name} (strength #{shield.strength}). WINNER IS #{winner.upcase} |"
        if (target_char_or_combatant.class == Combatant)
          target_char_or_combatant.log log_msg
        else
          Global.logger.info log_msg
        end

        if winner == "shield"
          msg = Magic.shield_success_msgs(target, caster_name, weapon_or_spell, shield.name)
          hit = false
        else
          msg = Magic.shield_failed_msgs(target, caster_name, weapon_or_spell),
          hit = true
        end

        return {
          msg: msg,
          shield: shield.name,
          hit: hit
        }
      end
      #There is no shield protecting against the damage type.
    end

    def self.shield_success_msgs(target, caster_name, weapon_or_spell, shield_name)
      #This is the issue - some spells give people a weapon they use to attack with, not just cast
      if Magic.is_spell?(weapon_or_spell) && !Global.read_config("spells", weapon_or_spell, "fs3_attack") || !Magic.is_spell?(weapon_or_spell)
        t('magic.shield_held_against_attack', :name => caster_name, :weapon => weapon_or_spell, :mod => "", :shield => shield_name, :target => target.name)
      else
        t('magic.shield_held_against_spell', :name => caster_name, :spell => weapon_or_spell, :mod => "", :shield => shield_name, :target => target.name)
      end
    end

    def self.shield_failed_msgs(target, caster_name, weapon_or_spell)
      damage_type =  Magic.magic_damage_type(weapon_or_spell)
      shield = Magic.find_best_shield(target, damage_type)
      type_does_damage = Global.read_config("magic",  "type_does_damage", damage_type)
      is_stun = Global.read_config("spells", weapon_or_spell, "is_stun") || FS3Combat.weapon_stat(weapon_or_spell, "is_stun") || false
      if weapon_or_spell.include?("Shrapnel")
          t('magic.shield_failed_against_shrapnel', :name => caster_name, :weapon => weapon_or_spell, :mod => "", :shield => shield.name, :target => target.name)
      elsif !Magic.is_spell?(weapon_or_spell)
        #shouldn't this also include weapons which ARE spells but are CAST by spells? IE Magic.is_spell?(weapon_or_spell) && !Global.read_config("spells", weapon_or_spell, "fs3_attack") || !Magic.is_spell?(weapon_or_spell)
        t('magic.shield_failed_against_attack', :name => caster_name, :weapon => weapon_or_spell, :mod => "", :shield => shield.name, :target => target.name)
      elsif type_does_damage
        t('magic.shield_failed_against_spell', :name => caster_name, :spell => weapon_or_spell, :mod => "", :shield => "Shield name", :target => target.name)
      elsif is_stun
         t('magic.shield_failed_stun', :name => caster_name, :spell => weapon_or_spell, :shield=> shield.name, :mod => "", :target => target.name, :rounds => Global.read_config("spells", weapon_or_spell, "rounds"))
      else
        t('magic.no_damage_shield_failed', :name => caster_name, :spell => weapon_or_spell, :mod => "", :shield => shield.name, :target => target.name)
      end
    end

    def self.shield_mods(target, damage_type)
      base = Global.read_config("magic", "shield_base_defense")
      multiplier = Global.read_config("magic", "shield_strength_multiplier")
      shield = Magic.find_best_shield(target, damage_type)
      shield_mod = (-base - (shield.strength * multiplier))
      target.log "#{shield.name} mod: #{shield_mod}"
      return shield_mod
    end



  end
end
