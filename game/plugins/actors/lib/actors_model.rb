module AresMUSH
  class Character
    has_one :actor_registry, dependent: :nullify
    
    def actor
      self.actor_registry ? self.actor_registry.actor : t('actors.actor_not_set')
    end
    
  end
  
  class ActorRegistry
     include SupportingObjectModel
     
     belongs_to :character
     
     field :charname, :type => String
     field :actor, :type => String
  end
end