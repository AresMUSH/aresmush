module AresMUSH
  class Character
    field :description, :type => String
    field :shortdesc, :type => String
    field :outfits, :type => Hash, :default => {}
        
    def has_outfit?(name)
      outfits.has_key?(name)
    end
    
    def outfit(name)
     outfits[name]
    end
  end
  
  class Room
    field :description, :type => String
    field :shortdesc, :type => String
  end
  
  class Exit
    field :description, :type => String
    field :shortdesc, :type => String
  end    
end
