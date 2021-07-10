module AresMUSH
  
  class Combat < Ohm::Model
    include ObjectModel
      
    attribute :is_real, :type => DataType::Boolean
    attribute :turn_in_progress, :type => DataType::Boolean
    attribute :first_turn, :type => DataType::Boolean, :default => true
    attribute :team_targets, :type => DataType::Hash, :default => {}
    attribute :everyone_posed, :type => DataType::Boolean, :default => false
    attribute :messages, :type => DataType::Array, :default => []
    
    reference :scene, "AresMUSH::Scene"
    reference :organizer, "AresMUSH::Character"
    collection :combatants, "AresMUSH::Combatant"
    collection :vehicles, "AresMUSH::Vehicle"

    before_delete :delete_objects
    
    reference :debug_log, "AresMUSH::CombatLog"
    
    def delete_objects
      combatants.each { |c| c.delete }
      vehicles.each { |v| v.delete }
      debug_log.delete if debug_log
    end
    
    def active_combatants
      combatants.select { |c| !c.is_noncombatant? }.sort_by{ |c| c.name }
    end
    
    def non_combatants
      combatants.select { |c| c.is_noncombatant? }.sort_by{ |c| c.name }
    end
    
    def is_real?
      is_real
    end
      
    def has_combatant?(name)
      !!find_combatant(name)
    end
      
    def find_combatant(name)
      combatants.select { |c| c.name.upcase == name.upcase }.first
    end
    
    # Finds a vehicle, combatant or NPC
    def find_named_thing(name)
      combatant = self.find_combatant(name)
      return combatant.associated_model if combatant
      self.find_vehicle_by_name(name)
    end
   
    def find_vehicle_by_name(name)
      self.vehicles.select { |v| v.name.upcase == name.upcase }.first
    end
    
    def log(msg)
      if (!self.debug_log)
        combat_log = CombatLog.create(combat: self)
        self.update(debug_log: combat_log)
      end
      Global.logger.debug msg
      self.debug_log.add msg
    end
  end
end