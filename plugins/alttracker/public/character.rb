module AresMUSH
  class Character
    # Many-to-one: each Character points to at most one AltTrackerRecord
    reference :alt_tracker, "AresMUSH::AltTrackerRecord"
  end
end
