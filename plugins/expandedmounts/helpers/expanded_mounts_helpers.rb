require 'byebug'
module AresMUSH
  module ExpandedMounts

    def self.mounted_names(combatant_or_mount)
      if combatant_or_mount.is_mount? && combatant_or_mount.rider
        return t('expandedmounts.combat_name', :combatant => combatant_or_mount.bonded.name, :mount => combatant_or_mount.name )
      elsif combatant_or_mount.class == Combatant && combatant_or_mount.riding
        return t('expandedmounts.combat_name', :combatant => combatant_or_mount.name, :mount => combatant_or_mount.riding.name )
      else
        return combatant_or_mount.name
      end
    end

    def self.join_mount(combat, combatant, mount, passenger_type)
      mount.update(combat: combat)
      combatant.update(expanded_mount_type: mount.expanded_mount_type)

      if (passenger_type == "Rider")
        mount.update(rider: combatant)
        combatant.update(riding: mount)

        FS3Combat.set_weapon(nil, combatant, mount.default_weapon)
        FS3Combat.set_armor(nil, mount, mount.default_armor)

        FS3Combat.emit_to_combat combat, t('expandedmounts.new_rider', :name => combatant.name, :mount => combatant.mount.name)
      else
        combatant.update(passenger_on: mount)
        FS3Combat.emit_to_combat combat, t('expandedmounts.new_passenger', :name => combatant.name, :mount => combatant.mount.name)
      end
    end

    def self.leave_mount(combatant)
      if combatant.mount.is_ko
        FS3Combat.emit_to_combat combatant.combat, t('expandedmounts.ko_dismount', :name => combatant.name, :mount => combatant.mount.name)
      else
        FS3Combat.emit_to_combat combatant.combat, t('expandedmounts.dismounts', :name => combatant.name, :mount => combatant.mount.name)
      end

      if (combatant.riding)
        mount = combatant.riding
        mount.update(rider: nil)
        combatant.update(riding: nil)
      elsif (combatant.passenger_on)
        mount = combatant.passenger_on
        combatant.update(passenger_on: nil)
      end

      combatant.update(expanded_mount_type: nil)
      # Why do I need this? - Probably to give them their weapon back. Also to be sure they aren't still wielding sharp teeth or something.
      #  FS3Combat.set_default_gear(nil, combatant, Global.read_config("fs3combat", "default_type"))
    end

  def self.heal_wounds(mount)
    #cron heal
    wounds = mount.damage.select { |d| d.healing_points > 0 }
    return if wounds.empty?

    heal_dice = Global.read_config("expandedmounts", mount.expanded_mount_type, "heal_roll")
    roll = FS3Skills.roll_dice(heal_dice)
    successes = FS3Skills.get_success_level(roll)

    doctors = mount.doctors.map { |d| d.name }

    points = 1

    if (doctors.count > 0 || successes > 0)
      points += 1
    end

    Global.logger.info "Healing wounds on #{mount.name}: docs=#{doctors.join(",")} recovery=#{successes}."

    wounds.each do |d|
      FS3Combat.heal(d, points)
    end
  end

  def self.target_rider(spell)
    puts "HELLO CHECKING THIS"
    return true unless spell['fs3_attack'] || spell['heal_points'] || spell['damage_inflicted'] || spell['armor'] || spell['armor_specials']
    return false
  end

  def self.new_turn(combat)
    combat.mounts.each do |m|
      puts "Mounts new turn"
      FS3Combat.check_for_ko(m)
      Magic.death_new_turn(m)
      m.update(freshly_damaged: false)
    end
  end

  def self.combat_stop(combat)
    combat.mounts.each do |m|
      m.update(combat: nil)
      m.update(freshly_damaged: false)
      m.update(is_ko: false)
      m.update(rider: nil)
      m.update(passengers: nil)
    end
  end

  def self.determine_target(target, attacker, attacker_net_successes)
    return {hit_target: true, target: target } if !attacker
    hit_target = true
    #only run code if the target is a mount with a rider or a rider/passenger on a mount
    if (target.is_mount? && target.rider ) || (!target.is_mount? && target.mount)
      hit_target_chance = 100

      if target.is_mount?
        hit_target_chance = 90 + attacker_net_successes
      else
        if (attacker.mount)
          if FS3Combat.weapon_stat(attacker.weapon, "weapon_type") == "Melee"
            hit_target_chance = 75 + attacker_net_successes
          else
            hit_target_chance = 85 + attacker_net_successes
          end
        else
          if FS3Combat.weapon_stat(attacker.weapon, "weapon_type") == "Melee"
            hit_target_chance = 30 + attacker_net_successes
          else
            hit_target_chance = 75 + attacker_net_successes
          end
        end

      end

      roll = rand(100)
      puts "roll #{roll} hit_target #{hit_target_chance} net success #{attacker_net_successes}"
      result = roll >= hit_target_chance

      if result
        hit_target = false
        if target.is_mount? && target.rider
          target = target.rider
        elsif target.riding
          target = target.riding
        elsif target.passenger_on
          target = targer.passenger_on
        end
      end

    end

    target.log "Determined hit target for mounts: chance=#{hit_target_chance} roll=#{roll} result=#{result} target=#{target.name}"

    return {
      hit_target: hit_target,
      target: target
    }
  end

  def self.dice_to_roll_for_ability(mount_or_rider, roll_params)
    #mount_or_rider must be in combat - if rider, their mount must also be in combat
    ability = roll_params.ability
    mount_or_rider.class == Mount ? mount = mount_or_rider : mount = mount_or_rider.bonded
    mount_or_rider.class == Character ? char = mount_or_rider : char = mount_or_rider.rider
    combatant = char.combatant

    if ability == "Reflexes"
      mount_dice = Global.read_config("expandedmounts", mount.expanded_mount_type, "reflexes") + combatant.defense_stance_mod
      rider_dice = FS3Skills.dice_to_roll_for_ability(char, roll_params)
    elsif ability == "Melee" ||  ability == "Brawl"
      mount_dice = Global.read_config("expandedmounts", mount.expanded_mount_type, "attack")  + combatant.attack_stance_mod
      rider_dice = FS3Skills.dice_to_roll_for_ability(char, roll_params)
    elsif  ability == "Composure"
      mount_dice = Global.read_config("expandedmounts", mount.expanded_mount_type, "composure")
      rider_dice = FS3Skills.dice_to_roll_for_ability(char, roll_params)
    elsif ability == "Stealth"
      mount_dice = Global.read_config("expandedmounts", mount.expanded_mount_type, "stealth")
      rider_dice = FS3Skills.dice_to_roll_for_ability(char, roll_params)
    elsif ability == "Alterness"
      mount_dice = Global.read_config("expandedmounts", mount.expanded_mount_type, "alertness")
      rider_dice = FS3Skills.dice_to_roll_for_ability(char, roll_params)
    else
      #Don't average skills that mounts don't affect
      mount_dice = FS3Skills.dice_to_roll_for_ability(char, roll_params)
      rider_dice = FS3Skills.dice_to_roll_for_ability(char, roll_params)
      no_log = true
    end
    dice = (rider_dice + mount_dice) / 2
    if !no_log
      char.combatant.log "TOTAL #{roll_params.ability.upcase} DICE: #{char.name}'s #{rider_dice} (mod: #{roll_params.modifier}) + #{mount.name}'s #{mount_dice} / 2 = #{dice}"
    end
    puts "Grabbing rider and mount dice: #{rider_dice} + #{mount_dice} / 2 = #{dice}"

    return dice
  end

    # def self.copy_damage_to_mount(vehicles)
    #   vehicles.each do |vehicle|
    #     vehicle.damage.each do |wound|
    #       params = {
    #       :description => wound.description,
    #       :current_severity => wound.current_severity,
    #       :initial_severity => wound.initial_severity,
    #       :ictime_str => wound.ictime_str,
    #       :healing_points => wound.healing_points,
    #       :is_stun => wound.is_stun,
    #       :is_mock => wound.is_mock,
    #       :mount => Mount.named(vehicle.name)
    #       }
    #       Damage.create(params)
    #     end
    #   end
    # end

    # def self.remove_mount_link(vehicles)
    #   vehicles.each do |vehicle|
    #     mount = Mount.named(vehicle.name)
    #     mount.update(vehicle: nil)
    #   end
    # end



  end
end