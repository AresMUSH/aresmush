module AresMUSH
  class TimePrefs < Ohm::Model
    include ObjectModel
    
    attribute :timezone
    reference :character, "AresMUSH::Character"
  end
  
  class Character
    reference :time_prefs, "AresMUSH::TimePrefs"
  end
end