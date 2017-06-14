module AresMUSH
  
  puts "======================================================================="
  puts "Adding boot permission to everyone."
  puts "======================================================================="
    
  everyone = Role.find_one_by_name("approved")
  everyone.update(permissions: ["boot"] )
  puts "Upgrade complete!"
end