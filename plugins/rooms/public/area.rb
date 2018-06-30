module AresMUSH
  class Area < Ohm::Model
    include ObjectModel
    include FindByName
    
    attribute :name
    attribute :name_upcase
    attribute :description
  
    index :name_upcase
    
    collection :rooms, "AresMUSH::Room"
    reference :map, "AresMUSH::GameMap"
    
    before_save :save_upcase
    
    def save_upcase
      self.name_upcase = self.name ? self.name.upcase : nil
    end
  end
end

