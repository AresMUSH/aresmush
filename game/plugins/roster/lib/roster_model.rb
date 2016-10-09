module AresMUSH
  class Character
    reference :roster_registry, "AresMUSH::RosterRegistry"
    
    before_delete :delete_roster_registry
    
    def delete_roster_registry
      self.roster_registry.delete if self.roster_registry
    end
    
    def get_or_create_roster_registry
      registry = self.roster_registry
      if (!registry)
        registry = RosterRegistry.create(character: self)
        self.update(roster_registry: registry)
      end
      registry
    end
    
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