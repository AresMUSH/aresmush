module AresMUSH
  
  puts "======================================================================="
  puts "Changing headwiz password."
  puts "======================================================================="
  
  
  new_password = ENV['ares_rake_param'] || "change_me!"
  Game.master.master_admin.change_password(new_password)
  
  puts "Upgrade complete!  Password is now #{new_password}"
end