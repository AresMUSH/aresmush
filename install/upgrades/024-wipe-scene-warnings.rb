module AresMUSH
  
  puts "======================================================================="
  puts "Resetting scene deletion warnings."
  puts "======================================================================="
    
  Scene.all.each do |s|
    s.update(deletion_warned: false)
  end
  
  puts "Upgrade complete!"
end