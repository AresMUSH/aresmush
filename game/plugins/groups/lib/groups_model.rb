module AresMUSH
  class Character
    set :groups, "AresMUSH::Group"
  end
  
  class Group < Ohm::Model
    include ObjectModel
    
    attribute :name
    attribute :group_type
    attribute :description
    
    index :name
    index :group_type
  end
end