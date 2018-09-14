module AresMUSH
  class Character < Ohm::Model
    collection :potions_has, "AresMUSH::PotionsHas"
    collection :potions_creating, "AresMUSH::PotionsCreating"
    #DO NOT USE THIS, IT IS ONLY HERE TO FIX THE ERROR KILLING NESSIE AND ALL RELATED THINGS.
    attribute :creating_potions
    
    attribute :can_create_potions

  end
end

  class PotionsHas < Ohm::Model
    include ObjectModel
    
    attribute :name
    index :name
    reference :character, "AresMUSH::Character"
    
  end
  
  
  class PotionsCreating < Ohm::Model
    include ObjectModel
    
    attribute :name
    reference :character, "AresMUSH::Character"
    attribute :hours_to_creation
    index :name
  
  end