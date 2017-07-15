module AresMUSH
  class Room
    reference :scene, "AresMUSH::Scene"
    attribute :scene_set
    attribute :scene_nag, :type => DataType::Boolean, :default => true
  end
  
  class Character
    def scenes_starring
      Scene.all.select { |s| s.participants.include?(self) }
    end
  end
  
  class Scene < Ohm::Model
    include ObjectModel
    
    reference :room, "AresMUSH::Room"
    reference :owner, "AresMUSH::Character"
    attribute :date_completed, :type => DataType::Date
    
    attribute :title
    attribute :private_scene, :type => DataType::Boolean
    attribute :temp_room, :type => DataType::Boolean
    attribute :completed
    attribute :scene_type
    attribute :location
    attribute :summary
    attribute :shared
    attribute :logging_enabled, :type => DataType::Boolean, :default => true
    attribute :deletion_warned, :type => DataType::Boolean, :default => true
    attribute :icdate
    attribute :log
    
    set :related_scenes, "AresMUSH::Scene"
    collection :scene_poses, "AresMUSH::ScenePose"
    set :participants, "AresMUSH::Character"
    
    before_delete :delete_poses
    
    def is_private?
      self.private_scene
    end
    
    def created_date_str(char)
      OOCTime.local_short_timestr(char, self.created_at)
    end
    
    def poses_in_order
      scene_poses.to_a.sort_by { |p| p.sort_order }
    end
    
    def auto_participants
      scene_poses.select { |s| !s.is_system_pose? && !s.is_gm_pose? }
          .map { |s| s.character }
          .uniq { |c| c.id }
    end
    
    def all_participant_names
      scene_poses.select { |s| !s.is_system_pose? }
          .map { |s| s.character.name }
          .uniq
    end
    
    def delete_poses
      scene_poses.each { |p| p.delete }
    end
    
    def all_info_set?
      self.title && self.location && self.scene_type && self.summary
    end
    
    def date_title
      "#{self.icdate} - #{self.title}"
    end
    
    def owner_name
      self.owner ? self.owner.name : t('scenes.organizer_deleted')
    end
  end
  
  class ScenePose < Ohm::Model
    include ObjectModel

    reference :character, "AresMUSH::Character"
    reference :scene, "AresMUSH::Scene"
    attribute :pose
    attribute :is_setpose, :type => DataType::Boolean
    attribute :order
    
    def sort_order
      self.order ? self.order.to_i : self.id.to_i
    end
    
    def is_setpose?
      self.is_setpose
    end
    
    def is_system_pose?
      self.character == Game.master.system_character
    end
    
    def is_gm_pose?
      self.character.is_admin? || self.character.is_playerbit?
    end
    
    def can_edit?(actor)
      return true if Scenes.can_access_scene?(actor, self.scene)
      return true if actor == self.character
      return false
    end
  end
end