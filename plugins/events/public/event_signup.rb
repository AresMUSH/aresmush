module AresMUSH
  
  class EventSignup < Ohm::Model
    include ObjectModel
    
    reference :event, "AresMUSH::Event"
    reference :character, "AresMUSH::Character"
    attribute :comment
    
    def char_name
      self.character ? self.character.name : ""
    end
  end
end
