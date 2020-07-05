module AresMUSH
  class ReadTracker < Ohm::Model
    include ObjectModel

    reference :character, "AresMUSH::Character"
  end
end
