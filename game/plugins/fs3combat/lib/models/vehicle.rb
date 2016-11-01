module AresMUSH
  class Vehicle < Ohm::Model
    include ObjectModel
    include FindByName
    
    attribute :vehicle_type
    
    reference :combat, "AresMUSH::Combat"
    
    reference :pilot, 'AresMUSH::Combatant'
    collection :passengers, 'AresMUSH::Combatant', :riding_in
    collection :damage, 'AresMUSH::Damage'
    
    before_delete :clear_damage
    
    def name
      self.vehicle_type + '-' + self.id
    end
    
    def armor
      FS3Combat.vehicle_stat(self.vehicle_type, "armor")
    end
    
    def clear_damage
      self.damage.each { |d| d.delete }
    end
    
    def total_damage_mod
      FS3Combat.total_damage_mod(self)
    end
    
    def random_name
      self.vehicle_type + '-' + [*('A'..'Z')].shuffle[0,2].join + [*('0'..'9')].shuffle[0,4].join
    end
  end
end