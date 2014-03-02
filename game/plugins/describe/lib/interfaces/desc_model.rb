module AresMUSH
  class Character
    key :description, String
    key :glance, String
    key :outfits, Hash
    
    before_create :initialize_char
    
    def initialize_char
      @outfits = {}
    end
  end
  
  class Room
    key :description, String
  end
  
  class Exit
    key :description, String
  end  
end