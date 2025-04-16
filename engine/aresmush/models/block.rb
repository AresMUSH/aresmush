module AresMUSH
  class BlockRecord < Ohm::Model
    include ObjectModel
    
    attribute :block_type
    reference :owner, "AresMUSH::Character"
    reference :blocked, "AresMUSH::Character"
    
  end
end