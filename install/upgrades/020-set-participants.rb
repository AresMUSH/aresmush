module AresMUSH
  
  puts "======================================================================="
  puts "Setting participants in scenes."
  puts "======================================================================="
    
    
  Scene.all.each do |s|
    s.auto_participants.each do |p|
      s.participants.add p
    end
  end
  
  puts "Upgrade complete!"
end