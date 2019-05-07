module AresMUSH
  class PageMessage < Ohm::Model
    include ObjectModel
    
    reference :character, "AresMUSH::Character"
    reference :author, "AresMUSH::Character"
    
    attribute :thread_name
    attribute :message
  end
end