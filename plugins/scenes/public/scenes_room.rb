module AresMUSH
  class Room
    attribute :pose_order, :type => DataType::Hash, :default => {}
    attribute :scene_set
    attribute :scene_nag, :type => DataType::Boolean, :default => true
    reference :scene, "AresMUSH::Scene"
    
    def update_pose_order(name)
      order = pose_order
      order[name] = Time.now.to_s
      update(pose_order: order)
    end
    
    def remove_from_pose_order(name)
      order = pose_order
      order.delete name
      update(pose_order: order)
    end
    
    def sorted_pose_order
      pose_order.sort_by { |name, time| Time.parse(time) }
    end
  end
end
