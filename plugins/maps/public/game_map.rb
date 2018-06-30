module AresMUSH
  class GameMap < Ohm::Model
    include ObjectModel
    include FindByName
    
    attribute :name
    attribute :name_upcase
    attribute :map_text

    collection :areas, "AresMUSH::Area", :map
    
    index :name_upcase
    
    before_save :save_upcase
    
    def area_names
      areas.map { |a| a.name }
    end
    
    def save_upcase
      self.name_upcase = self.name.upcase
    end      
    
  end
end