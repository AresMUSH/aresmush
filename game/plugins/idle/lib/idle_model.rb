module AresMUSH
  class Character
    reference :idle_status, "AresMUSH::IdleStatus"
    attribute :idle_warned
    reference :roster_registry, "AresMUSH::RosterRegistry"
    attribute :idle_lastwill
    
    before_delete :delete_idle_status
    
    def get_or_create_roster_registry
      registry = self.roster_registry
      if (!registry)
        registry = RosterRegistry.create(character: self)
        self.update(roster_registry: registry)
      end
      registry
    end
    
    def delete_idle_status
      self.idle_status.delete if self.idle_status
      self.roster_registry.delete if self.roster_registry
    end
    
    def get_or_create_idle_status
      status = self.idle_status
      if (!status)
        status = IdleStatus.create(character: self)
        self.update(idle_status: status)
      end
      status
    end
  end
  
  class RosterRegistry < Ohm::Model
    include ObjectModel
     
     reference :character, "AresMUSH::Character"
     attribute :contact
  end
  
  class IdleStatus < Ohm::Model
    include ObjectModel
    
    attribute :status    
    reference :character, "AresMUSH::Character"
  end
end