module AresMUSH
  class Room
    attribute :description
    attribute :shortdesc
    attribute :details, :type => DataType::Hash, :default => {}
    attribute :vistas, :type => DataType::Hash, :default => {}
    
    def expanded_desc
      Describe::RoomDescBuilder.build(self)
    end
  end
  
  class Exit
    attribute :description
    attribute :shortdesc
    attribute :details, :type => DataType::Hash, :default => {}
  end    
end
