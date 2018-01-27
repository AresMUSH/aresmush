module AresMUSH  
  class Friendship < Ohm::Model
    include ObjectModel
  
    reference :character, "AresMUSH::Character"
    reference :friend, "AresMUSH::Character"
  
    attribute :note
  end
end