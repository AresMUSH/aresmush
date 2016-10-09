module AresMUSH
  class Character
    collection :group_assignments, "AresMUSH::GroupAssignment"
    
    before_delete :delete_groups
    
    def delete_groups
      self.group_assignments.each { |g| g.delete }
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