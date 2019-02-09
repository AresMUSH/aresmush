module AresMUSH
  class Character
    attribute :pose_nospoof, :type => DataType::Boolean
    attribute :pose_autospace, :default => "%r"
    attribute :pose_quote_color
    attribute :pose_nudge, :type => DataType::Boolean, :default => true
    attribute :pose_nudge_muted, :type => DataType::Boolean
    attribute :pose_word_count, :type => DataType::Integer
    attribute :scene_home
  
    def autospace
      self.pose_autospace
    end
    
    def autospace=(value)
      self.update(pose_autospace: value)
    end
    
    def last_posed
      last_pose_time = self.room.pose_order[self.name]
      return nil if !last_pose_time
      TimeFormatter.format(Time.now - Time.parse(last_pose_time))
    end
    
    def scenes_starring
      Scene.scenes_starring(self)
    end
    
    def unshared_scenes
      Scene.all.select { |s| s.completed && !s.shared && s.participants.include?(self) }
    end
  end
end