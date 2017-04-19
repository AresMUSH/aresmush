module AresMUSH
  
  class Character
    collection :group_assignments, "AresMUSH::GroupAssignment"
  end
  
  class GroupAssignment < Ohm::Model
    include ObjectModel
    
    reference :character, "AresMUSH::Character"
    
    attribute :group
    attribute :value
    
    index :group
    index :value
  end
  
  puts "======================================================================="
  puts "Moves groups onto the character itself."
  puts "======================================================================="

  Character.all.each { |c| c.update(groups: {} )}
  GroupAssignment.all.each do |g|
    groups = g.character.groups
    groups[g.group] = g.value
    g.character.update(groups: groups)    
    g.delete
   end
   
  puts "Upgrade complete!"
end



