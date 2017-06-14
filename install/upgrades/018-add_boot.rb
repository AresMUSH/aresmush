module AresMUSH
  
  puts "======================================================================="
  puts "Adding boot permission to everyone."
  puts "======================================================================="
    
  everyone = Role.find_one_by_name("everyone")
  permissions = everyone.permissions
  permissions << "boot"
  everyone.update(permissions: permissions )
  puts "Upgrade complete!"
end