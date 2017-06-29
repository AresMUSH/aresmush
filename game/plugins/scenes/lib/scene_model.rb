module AresMUSH
  class Character
    attribute :repose_nudge, :type => DataType::Boolean, :default => true
    attribute :repose_nudge_muted, :type => DataType::Boolean
  end
  
  class Room
    reference :scene, "AresMUSH::Scene"
    attribute :scene_set
    reference :repose_info, "AresMUSH::ReposeInfo"
  end
  
  class Scene < Ohm::Model
    include ObjectModel
    
    reference :room, "AresMUSH::Room"
    reference :owner, "AresMUSH::Character"
    
    attribute :title
    attribute :private_scene, :type => DataType::Boolean
    attribute :completed
    attribute :location
    attribute :summary
    attribute :ictime, :type => DataType::Date
    
    collection :scene_poses, "AresMUSH::ScenePose"
    
    before_delete :delete_poses
    
    def is_private?
      self.private_scene
    end
    
    def created_date_str(char)
      OOCTime::Api.local_short_timestr(char, self.created_at)
    end
    
    def participants
      scene_poses.select { |s| !s.is_system_pose? && !s.is_gm_pose? }
          .map { |s| s.character }
          .uniq { |c| c.id }
    end
    
    def delete_poses
      scene_poses.each { |p| p.delete }
    end
  end
  
  class ScenePose < Ohm::Model
    include ObjectModel

    reference :character, "AresMUSH::Character"
    reference :scene, "AresMUSH::Scene"
    attribute :pose
    
    def is_system_pose?
      self.character == Game.master.system_character
    end
    
    def is_gm_pose?
      self.character.is_admin? || self.character.is_playerbit?
    end
    
    def can_edit?(actor)
      return true if Scenes.can_manage_scene(actor, self.scene)
      return true if actor == self.character
      return false
    end
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
  
  
end