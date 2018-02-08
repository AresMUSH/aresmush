module AresMUSH
  
  class Character
    include Describable
    
    attribute :desc_notify, :type => DataType::Boolean, :default => true
    
    def shortdesc
      descs_of_type("short").first
    end
    
    # -------------------------------
    # Outfits
    # -------------------------------
    
    def has_outfit?(name)
      !!outfit(name)
    end
    
    def outfit(name)
      outfits.find(name: name).first
    end
    
    def outfits
      descs_of_type(:outfit)
    end
  end
end
