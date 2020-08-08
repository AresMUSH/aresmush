module AresMUSH
  
  puts "======================================================================="
  puts "Changing headwiz password."
  puts "======================================================================="
  
  
  new_password = ENV['ares_rake_param'] 
  
  if (!new_password)
    puts "You must specify a password."
    exit
  end
  
  Game.master.master_admin.change_password(new_password)
  Game.master.master_admin.update(login_failures: 0)
  
  puts "Script complete!  Password is now #{new_password}"
end