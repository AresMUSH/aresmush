module AresMUSH
  
  puts "======================================================================="
  puts "Changing headwiz password back to the default: change_me!"
  puts "======================================================================="
  
  Game.master.master_admin.change_password("change_me!")
  
  puts "Upgrade complete!"
end