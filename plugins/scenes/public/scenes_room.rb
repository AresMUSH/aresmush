module AresMUSH
  class Room
    attribute :pose_order, :type => DataType::Hash, :default => {}
    attribute :scene_set
    attribute :scene_nag, :type => DataType::Boolean, :default => true
    attribute :pose_order_type, :default => "normal"
    
    reference :scene, "AresMUSH::Scene"
    
    def update_pose_order(name)
      order = pose_order
      order[name] = Time.now.to_s
      update(pose_order: order)
    end
    
    def remove_from_pose_order(name)
      order = pose_order
      key = order.keys.select { |k| k.downcase == name.downcase }.first
      order.delete key
      update(pose_order: order)
    end
    
    def sorted_pose_order
      pose_order.sort_by { |name, time| Time.parse(time) }
    end
    
    def logging_enabled?
      self.scene && self.scene.logging_enabled
    end
  end
end
