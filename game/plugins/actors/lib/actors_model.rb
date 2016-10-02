module AresMUSH
  class Character
    reference :actor_registry, "AresMUSH::ActorRegistry"
  end
  
  class ActorRegistry < Ohm::Model
    include ObjectModel
     
     reference :character, "AresMUSH::Character"

     attribute :charname
     attribute :actor
  end
end