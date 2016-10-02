module AresMUSH
  
  class CombatInstance
    include SupportingObjectModel
      
    field :is_real, :type => Boolean
    field :num, :type => Integer
    field :turn_in_progress, :type => Boolean
    field :first_turn, :type => Boolean, :default => true
    
    belongs_to :organizer, :class_name => "AresMUSH::Character", :inverse_of => "nil"  
    has_many :combatants, :inverse_of => 'combat', :dependent => :destroy
    has_many :vehicles, :inverse_of => 'combat', :dependent => :destroy

    def active_combatants
      combatants.select { |c| !c.is_noncombatant? }.sort_by{ |c| c.name }
    end
    
    def non_combatants
      combatants.select { |c| c.is_noncombatant? }.sort_by{ |c| c.name }
    end
    
    def self.next_num
      max = CombatInstance.all.max_by(&:num)
      max ? max.num + 1 : 1
    end
    
    def is_real?
      is_real
    end
      
    def has_combatant?(name)
      !find_combatant(name).nil?
    end
      
    def find_combatant(name)
      self.combatants.select { |c| c.name_upcase == name.upcase }.first
    end
      
    def join(name, combatant_type, char = nil)
      combatant = Combatant.create(:name => name, 
        :combatant_type => combatant_type, 
        :character => char,
        :team => char ? 1 : 2)
      self.combatants << combatant
      emit t('fs3combat.has_joined', :name => name, :type => combatant_type)
      return combatant
    end
        
    def leave(name)
      emit t('fs3combat.has_left', :name => name)
      combatant = find_combatant(name)
      combatant.clear_mock_damage          
      self.combatants.delete combatant
      combatant.destroy
    end

    def find_vehicle_by_name(name)
      self.vehicles.select { |v| v.name.upcase == name.upcase }.first
    end
    
    def find_or_create_vehicle(name)
      existing = find_vehicle_by_name(name)
      if (existing)
        return existing
      elsif (FS3Combat.vehicles.include?(name))
        random_name = name + '-' + [*('A'..'Z')].shuffle[0,2].join + [*('0'..'9')].shuffle[0,4].join
        Vehicle.create(combat: self, name: random_name, vehicle_type: name)
      else
        return nil
      end
    end

    def join_vehicle(combatant, vehicle, passenger_type)
      old_pilot = vehicle.pilot
      
      if (passenger_type == "Pilot")
        vehicle.pilot = combatant

        default_weapon = FS3Combat.vehicle_stat(vehicle.vehicle_type, "weapons").first
        FS3Combat.set_weapon(nil, combatant, default_weapon)
        
        if (old_pilot && old_pilot != combatant)
          vehicle.passengers << old_pilot
        end
        emit t('fs3combat.new_pilot', :name => combatant.name, :vehicle => vehicle.name)
      else
        vehicle.passengers << combatant
        emit t('fs3combat.new_passenger', :name => combatant.name, :vehicle => vehicle.name)
      end
      vehicle.save
    end
    
    def leave_vehicle(combatant)
      vehicle = combatant.piloting
       if (vehicle)
         combatant.piloting = nil
         combatant.save
       else
         vehicle = combatant.riding_in
         vehicle.passengers.delete combatant
       end
       emit t('fs3combat.disembarks_vehicle', :name => combatant.name, :vehicle => vehicle.name)
       vehicle.save
    end
    
    def emit(message, npcmaster = nil)
      message = message + "#{npcmaster}"
      self.combatants.each { |c| c.emit(message)}
    end
      
    def emit_to_organizer(message, npcmaster = nil)
      message = message + " (#{npcmaster})" if npcmaster
        
      client = self.organizer.client
      if (client)
        client.emit t('fs3combat.organizer_emit', :message => message)
      end
    end
    
    def roll_initiative
      ability = Global.read_config("fs3combat", "initiative_ability")
      order = []
      self.combatants.each do |c|
        roll = c.roll_initiative(ability)
        order << { :combatant => c, :roll => roll }
      end
      Global.logger.debug "Combat initiative rolls: #{order.map { |o| "#{o[:combatant].name}=#{o[:roll]}" }}"
      order.sort_by { |c| c[:roll] }.map { |c| c[:combatant] }
    end
    
    def ai_action(client, combatant)
      if (combatant.ammo == 0)
        FS3Combat.set_action(client, nil, self, combatant, FS3Combat::ReloadAction, "")
        # TODO - Use suppress attack for suppress only weapon
      else
        target = active_combatants.select { |t| t.team != combatant.team }.shuffle.first
        if (target)
          FS3Combat.set_action(client, nil, self, combatant, FS3Combat::AttackAction, target.name)
        end
      end   
    end
  end
end