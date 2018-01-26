module AresMUSH
  module FS3Combat
    
    def self.find_or_create_vehicle(combat, name)
      existing = combat.find_vehicle_by_name(name)
      if (existing)
        return existing
      end
        
      vehicle = FS3Combat.vehicles.select { |k, v| k.titlecase == name.titlecase }
      if (vehicle.keys[0])
        name = vehicle.keys[0]
        Vehicle.create(combat: combat, vehicle_type: name)
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
        FS3Combat.emit_to_combat combat, t('fs3combat.new_pilot', :name => combatant.name, :vehicle => vehicle.name)
      else
        combatant.update(riding_in: vehicle)
        FS3Combat.emit_to_combat combat, t('fs3combat.new_passenger', :name => combatant.name, :vehicle => vehicle.name)
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
       FS3Combat.set_default_gear(nil, combatant, Global.read_config("fs3combat", "default_type"))
       
       FS3Combat.emit_to_combat combat, t('fs3combat.disembarks_vehicle', :name => combatant.name, :vehicle => vehicle.name)
    end
    
    def self.vehicle_dodge_mod(combatant)
      return 0 if !combatant.is_in_vehicle?
      
      FS3Combat.vehicle_stat(combatant.vehicle.vehicle_type, "dodge")
    end
  end
end