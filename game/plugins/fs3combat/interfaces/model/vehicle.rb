module AresMUSH
  class Vehicle
    include SupportingObjectModel
  
    field :name, :type => String
    field :damage, :type => Array, :default => []
    field :vehicle_type, :type => String
    
    belongs_to :combat, :class_name => "AresMUSH::CombatInstance"
    
    has_one :pilot, :class_name => 'AresMUSH::Combatant', :inverse_of => :piloting
    has_many :passengers, :class_name => 'AresMUSH::Combatant', :inverse_of => :riding_in
  end
end