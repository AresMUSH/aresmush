require 'byebug'
module AresMUSH
  module ExpandedMounts

    def self.find_or_create_vehicle(combat, name)
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
    
    def self.join_vehicle(combat, combatant, vehicle, passenger_type)
      old_pilot = vehicle.pilot
      
      if (passenger_type == "Pilot")
        vehicle.update(pilot: combatant)
        combatant.update(piloting: vehicle)
        
        default_weapon = FS3Combat.vehicle_stat(vehicle.vehicle_type, "weapons").first
        FS3Combat.set_weapon(nil, combatant, default_weapon)
        
        if (old_pilot && old_pilot != combatant)
          old_pilot.update(piloting: nil)
          old_pilot.update(riding_in: vehicle)
        end
        FS3Combat.emit_to_combat combat, t('expandedmounts.new_pilot', :name => combatant.name, :vehicle => combatant.mount_name)
      else
        combatant.update(riding_in: vehicle)
        FS3Combat.emit_to_combat combat, t('expandedmounts.new_passenger', :name => combatant.name, :vehicle => combatant.mount_name)
      end
    end
    
    def self.leave_vehicle(combat, combatant)
      
       if (combatant.piloting)
         vehicle = combatant.piloting
         vehicle.update(pilot: nil)
         combatant.update(piloting: nil)
       elsif (combatant.riding_in)
         vehicle = combatant.riding_in
         combatant.update(riding_in: nil)
       end
      # Why do I need this? - Probably to give them their weapon back.
      #  FS3Combat.set_default_gear(nil, combatant, Global.read_config("fs3combat", "default_type"))
       
       FS3Combat.emit_to_combat combat, t('expandedmounts.disembarks_vehicle', :name => combatant.name, :vehicle => combatant.mount_name)
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