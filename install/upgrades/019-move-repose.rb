module AresMUSH
  
  puts "======================================================================="
  puts "Moving around repose info."
  puts "======================================================================="
    
    
  class Character
    attribute :repose_nudge, :type => DataType::Boolean, :default => true
  end
  
  Character.all.each do |c|
    c.update(pose_nudge: c.repose_nudge)
    c.update(repose_nudge: nil)
  end
  
  Room.all.each do |r|
    r.update(pose_order: {})
  end
  
  puts "Upgrade complete!"
end