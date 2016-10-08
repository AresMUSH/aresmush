module AresMUSH
  class Character
    collection :group_assignments, "AresMUSH::GroupAssignment"
    
    def group(name)
      GroupAssignment.find(character_id: self.id).combine(group: name).first
    end
  end
  
  class GroupAssignment < Ohm::Model
    include ObjectModel
    
    reference :character, "AresMUSH::Character"
    
    attribute :group
    attribute :value
    
    index :group
    index :value
  end
end