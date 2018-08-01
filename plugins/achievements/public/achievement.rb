module AresMUSH
  class Achievement< Ohm::Model
    include ObjectModel
    
    reference :character, "AresMUSH::Character"
    attribute :type
    attribute :name
    attribute :message
  end
end