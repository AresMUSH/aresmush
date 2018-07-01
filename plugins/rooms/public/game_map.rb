module AresMUSH
  # DEPRECATED!  DO NOT USE
  class GameMap < Ohm::Model
    include ObjectModel
    include FindByName
    
    attribute :name
    attribute :name_upcase
    attribute :map_text

    attribute :areas, :type => DataType::Array
    
    index :name_upcase
    
    before_save :save_upcase
    
    def save_upcase
      self.name_upcase = self.name.upcase
    end      
    
  end
end