module AresMUSH
  class Vehicle < Ohm::Model
    include ObjectModel
  
    attribute :name
    attribute :damage, :type => DataType::Array, :default => []
    attribute :vehicle_type
    
    reference :combat, "AresMUSH::Combat"
    
    reference :pilot, 'AresMUSH::Combatant'
    collection :passengers, 'AresMUSH::Combatant'
  end
end