module AresMUSH
  
  puts "======================================================================="
  puts "Moving around repose info."
  puts "======================================================================="
    
    
  class Room
    reference :repose_info, "AresMUSH::ReposeInfo"
  end

  class PoseOrder < Ohm::Model
    include ObjectModel
    
    attribute :time, :type => DataType::Time

    reference :character, "AresMUSH::Character"
    reference :repose_info, "AresMUSH::ReposeInfo"
  end
  
  class ReposeInfo < Ohm::Model
    include ObjectModel
    
    reference :room, "AresMUSH::Room"
    
    attribute :first_turn, :type => DataType::Boolean, :default => true
    attribute :poses, :type => DataType::Array, :default => []
    attribute :enabled, :type => DataType::Boolean, :default => true
    collection :pose_orders, "AresMUSH::PoseOrder"
    
    def reset
      pose_orders.each { |po| po.delete }
      self.update(poses: [])
      self.update(first_turn: true)
    end
    
    def sorted_orders
      self.pose_orders.to_a.sort { |p1, p2| p1.time <=> p2.time }
    end
  end
  
  class Character
    attribute :repose_nudge, :type => DataType::Boolean, :default => true
  end
  
  PoseOrder.all.each { |p| p.delete }
  ReposeInfo.all.each { |r| r.delete }
  Room.all.each { |r| r.update(repose_info: nil) }
  Scene.all.each { |s| s.delete }
  
  Character.all.each do |c|
    c.update(pose_nudge: c.repose_nudge)
    c.update(repose_nudge: nil)
  end
  
  Room.all.each do |r|
    r.update(pose_order: {})
  end
  
  puts "Upgrade complete!"
end