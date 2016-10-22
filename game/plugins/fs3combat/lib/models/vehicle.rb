module AresMUSH
  class Vehicle < Ohm::Model
    include ObjectModel
    include FindByName
    
    attribute :name
    attribute :name_upcase
    attribute :damage, :type => DataType::Array, :default => []
    attribute :vehicle_type
    
    reference :combat, "AresMUSH::Combat"
    
    reference :pilot, 'AresMUSH::Combatant'
    collection :passengers, 'AresMUSH::Combatant'
    
    before_save :save_upcase
    
    def save_upcase
      self.name_upcase = self.name ? self.name.upcase : nil
    end
  end
end