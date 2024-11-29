module AresMUSH
  
  class Character
    attribute :desc_notify, :type => DataType::Boolean, :default => false
    attribute :description
    attribute :previous_desc
    attribute :shortdesc
    attribute :outfits, :type => DataType::Hash, :default => {}
    attribute :details, :type => DataType::Hash, :default => {}
    
    # -------------------------------
    # Outfits
    # -------------------------------
    
    def has_outfit?(name)
      !!outfit(name)
    end
    
    def outfit(name)
      outfits[name]
    end
    
    def update_desc(new_desc)
      self.update(previous_desc: self.description)
      self.update(description: new_desc)
    end
  end
end
