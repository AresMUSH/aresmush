module AresMUSH
  class Character
    has_one :roster_registry, dependent: :nullify
  end
  
  class RosterRegistry
     include Mongoid::Document
     
     belongs_to :character
     
     field :contact, :type => String
  end
end