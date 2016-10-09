module AresMUSH
  class Character
    reference :actor_registry, "AresMUSH::ActorRegistry"
    
    before_delete :delete_actor
    
    def delete_actor
      self.actor_registry.delete if self.actor_registry
    end
  end
  
  class ActorRegistry < Ohm::Model
    include ObjectModel
     
     reference :character, "AresMUSH::Character"

     attribute :charname
     attribute :actor
  end
end