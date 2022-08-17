require 'byebug'
module AresMUSH
  module ExpandedMounts

    # def self.find_or_create_mount(combat, name)
    #   #Find a vehicle by link to mount model
    #   mount = Mount.named(name)
    #   return mount.vehicle if mount.vehicle
    #   # if (existing)
    #   #   return existing
    #   # end
 
    #   vehicle_type = mount.mount_type
    #   #checking the list of vehicle types in config to see whether 'name' is there.
    #   vehicle = FS3Combat.vehicles.select { |k, v| k.titlecase == vehicle_type.titlecase }
    #   if (vehicle.keys[0])
    #     type = vehicle.keys[0]
    #     Vehicle.create(combat: combat, vehicle_type: type, name: name)
        
    #   else
    #     return nil
    #   end
    # end
    
    def self.join_mount(combat, combatant, mount, passenger_type)
      puts "Combat: #{combat} - #{mount.combat}"
      mount.update(combat: combat)
      puts "Mount: #{mount.name} Combat: #{mount.combat}"
      combatant.update(expanded_mount_type: mount.expanded_mount_type)

      if (passenger_type == "Rider")
        mount.update(rider: combatant)
        combatant.update(riding: mount)
                
        FS3Combat.set_weapon(nil, combatant, mount.default_weapon)
        
        FS3Combat.emit_to_combat combat, t('expandedmounts.new_rider', :name => combatant.name, :mount => combatant.mount.name)
      else
        combatant.update(passenger_on: mount)
        FS3Combat.emit_to_combat combat, t('expandedmounts.new_passenger', :name => combatant.name, :mount => combatant.mount.name)
      end
    end
    
    def self.leave_mount(combat, combatant)
      FS3Combat.emit_to_combat combat, t('expandedmounts.dismounts', :name => combatant.name, :mount => combatant.mount.name)

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
    return true unless spell['fs3_attack'] || spell['heal_points'] || spell['damage_inflicted']
    return false
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