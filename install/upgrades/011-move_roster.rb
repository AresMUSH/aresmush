module AresMUSH
  
  class Character
    reference :roster_registry, "AresMUSH::RosterRegistry"
    reference :idle_status, "AresMUSH::IdleStatus"
  end
  
  class RosterRegistry < Ohm::Model
    include ObjectModel
     
     reference :character, "AresMUSH::Character"
     attribute :contact
  end
  
  class IdleStatus < Ohm::Model
    include ObjectModel
    
    attribute :status    
    reference :character, "AresMUSH::Character"
  end
  
  puts "======================================================================="
  puts "Moves roster and idle fields onto the character itself."
  puts "======================================================================="
  
  IdleStatus.all.each do |i|
     i.character.update(idle_state: i.status)
     i.delete
   end
   
  RosterRegistry.all.each do |r|
     r.character.update(roster_contact: r.contact) 
     r.character.update(idle_state: "Roster") 
     r.delete
  end

  Character.all.each do |c|
    c.update(roster_registry_id: nil)
    c.update(idle_status_id: nil)
  end
  
  
  puts "Upgrade complete!"
end



