module AresMUSH
  class Character
    has_one :roster_registry, dependent: :nullify
    
    def on_roster?
      roster_registry ? true : false
    end
  end
  
  class RosterRegistry
    include SupportingObjectModel
     
     belongs_to :character
     
     field :contact, :type => String
  end
end