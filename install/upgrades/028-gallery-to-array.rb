module AresMUSH
  
  puts "======================================================================="
  puts "Converting Gallery from string to array."
  puts "======================================================================="
  
 
  
  Character.all.each do |c|
    c.update(profile_gallery: [])
  end
  
  puts "Upgrade complete!"
end