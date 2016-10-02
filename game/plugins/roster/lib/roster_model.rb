module AresMUSH
  class Character
    reference :roster_registry, "AresMUSH::RosterRegistry"
    
    def on_roster?
      !!roster_registry
    end
  end
  
  class RosterRegistry < Ohm::Model
    include ObjectModel
     
     reference :character, "AresMUSH::Character"
     
     attribute :contact
  end
end