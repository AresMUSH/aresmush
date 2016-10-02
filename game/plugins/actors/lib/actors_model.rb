module AresMUSH
  class Character
    reference :actor_registry, "AresMUSH::ActorRegistry"
    
    def actor
      self.actor_registry ? self.actor_registry.actor : t('actors.actor_not_set')
    end
    
  end
  
  class ActorRegistry < Ohm::Model
    include ObjectModel
     
     reference :character, "AresMUSH::Character"

     attribute :charname
     attribute :actor
  end
end