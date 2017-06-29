module AresMUSH
  class Room
    reference :scene, "AresMUSH::Scene"
    attribute :scene_set
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
end