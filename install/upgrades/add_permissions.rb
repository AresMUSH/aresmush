module AresMUSH
  
  puts "======================================================================="
  puts "Adding permissions to roles."
  puts "======================================================================="
  

  Role.all.each do |r|
    r.update(permissions: [])
  end
  
  builder = Role.find_one_by_name("builder")
  builder.update(permissions: ["desc_places", "setup_hospitals", "manage_rooms", "build", "teleport"])
  
  everyone = Role.find_one_by_name("everyone")
  everyone.update(permissions: ["go_home"] )
  puts "Upgrade complete!"
end