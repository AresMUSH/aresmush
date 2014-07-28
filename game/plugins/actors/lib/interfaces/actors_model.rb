module AresMUSH
  class Character
    has_one :actor_registry, dependent: :nullify
  end
  
  class ActorRegistry
     include Mongoid::Document
     
     belongs_to :character
     
     field :charname, :type => String
     field :actor, :type => String
  end
end