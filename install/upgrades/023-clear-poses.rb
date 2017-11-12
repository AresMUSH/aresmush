module AresMUSH
  
  puts "======================================================================="
  puts "Clearing out old scene poses."
  puts "======================================================================="
    
  Scene.all.each do |s|
    if (s.shared)
      s.scene_poses.each { |p| p.delete }
    end
  end
  
  puts "Upgrade complete!"
end