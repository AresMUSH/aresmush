module AresMUSH
  class ProfileVersion < Ohm::Model
    include ObjectModel
    
    attribute :text    
    reference :character, "AresMUSH::Character"
    reference :author, "AresMUSH::Character"
    
    def author_name
      self.author ? self.author.name : "--"
    end
  end
  
end