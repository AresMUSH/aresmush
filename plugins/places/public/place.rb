module AresMUSH
  
  class Place < Ohm::Model
    include ObjectModel
    include FindByName
    
    set :characters, "AresMUSH::Character"
    reference :room, "AresMUSH::Room"
    
    attribute :name
    attribute :name_upcase
    index :name_upcase
    
    before_save :save_upcase
    
    def save_upcase
      self.name_upcase = self.name ? self.name.upcase : nil
    end
    
  end
end