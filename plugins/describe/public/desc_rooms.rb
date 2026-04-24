module AresMUSH
  class Room
    attribute :description
    attribute :shortdesc
    attribute :previous_desc
    attribute :details, :type => DataType::Hash, :default => {}
    attribute :vistas, :type => DataType::Hash, :default => {}
    
    def expanded_desc
      Describe::RoomDescBuilder.build(self)
    end
    
    def update_desc(new_desc)
      self.update(previous_desc: self.description)
      self.update(description: new_desc)
    end
  end
  
  class Exit
    attribute :description
    attribute :shortdesc
    attribute :previous_desc
    
    attribute :details, :type => DataType::Hash, :default => {}
    
    def update_desc(new_desc)
      self.update(previous_desc: self.description)
      self.update(description: new_desc)
    end
  end    
end
