module AresMUSH
  class Character
    key :description, String
    key :shortdesc, String
    key :outfits, Hash
    
    before_create :initialize_char
    
    def has_outfit?(name)
      outfits.has_key?(name)
    end
    
    def outfit(name)
     outfits[name]
    end
  end
  
  class Room
    key :description, String
  end
  
  class Exit
    key :description, String
  end    
end