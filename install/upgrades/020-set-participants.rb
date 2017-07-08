module AresMUSH
  
  puts "======================================================================="
  puts "Setting participants in scenes."
  puts "======================================================================="
    
    
  Scene.all.each do |s|
    s.participants.replace []
    s.auto_participants.each do |p|
      s.participants.add p
    end
  end
  
  Room.all.each { |r| r.update(scene_nag: true)}
  
  puts "Upgrade complete!"
end