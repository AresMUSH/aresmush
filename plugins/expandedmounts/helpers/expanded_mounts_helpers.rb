require 'byebug'
module AresMUSH
  module ExpandedMounts

    def self.find_or_create_mount(combat, name)
      #Find a vehicle by link to mount model
      mount = Mount.named(name)
      return mount.vehicle if mount.vehicle
      # if (existing)
      #   return existing
      # end
 
      vehicle_type = mount.mount_type
      #checking the list of vehicle types in config to see whether 'name' is there.
      vehicle = FS3Combat.vehicles.select { |k, v| k.titlecase == vehicle_type.titlecase }
      if (vehicle.keys[0])
        type = vehicle.keys[0]
        Vehicle.create(combat: combat, vehicle_type: type, name: name)
        
      else
        return nil
      end
    end
    
    def self.join_mount(combat, combatant, mount, passenger_type)
      puts "Combat: #{combat} - #{mount.combat}"
      mount.update(combat: combat)
      puts "Mount: #{mount.name} Combat: #{mount.combat}"
      old_rider = mount.rider

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
      # Why do I need this? - Probably to give them their weapon back.
      #  FS3Combat.set_default_gear(nil, combatant, Global.read_config("fs3combat", "default_type"))
       
       
    end

    def self.copy_damage_to_mount(vehicles)
      vehicles.each do |vehicle|
        vehicle.damage.each do |wound|
          params = {
          :description => wound.description,
          :current_severity => wound.current_severity,
          :initial_severity => wound.initial_severity,
          :ictime_str => wound.ictime_str,
          :healing_points => wound.healing_points,
          :is_stun => wound.is_stun, 
          :is_mock => wound.is_mock,
          :mount => Mount.named(vehicle.name)
          }
          Damage.create(params)
        end
      end
    end

    def self.remove_mount_link(vehicles)
      vehicles.each do |vehicle|
        mount = Mount.named(vehicle.name)
        mount.update(vehicle: nil)
      end
    end



  end
end