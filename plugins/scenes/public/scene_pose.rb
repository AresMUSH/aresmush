module AresMUSH
  class ScenePose < Ohm::Model
    include ObjectModel

    reference :character, "AresMUSH::Character"
    reference :scene, "AresMUSH::Scene"
    attribute :pose
    attribute :place_name
    attribute :is_setpose, :type => DataType::Boolean
    attribute :is_ooc, :type => DataType::Boolean
    attribute :order
    attribute :pose_type
    attribute :is_deleted, :type => DataType::Boolean
    attribute :restarted_scene_pose, :type => DataType::Boolean
    attribute :history, :type => DataType::Array, :default => []
    
    def move_to_history
      entries = self.history || []
      entries << "#{Time.now} #{character ? character.name : t('global.deleted_character')} -- #{pose}"
      self.update(history: entries)
    end
    
    def sort_order
      self.order ? self.order.to_i : self.id.to_i
    end
    
    def is_deleted?
      self.is_deleted
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
    
    def is_real_pose?
      return true if self.restarted_scene_pose
      return false if self.is_deleted
      return false if self.is_ooc
      return false if self.is_system_pose?
      return true
    end
    
    def can_edit?(actor)
      return false if !actor
      return false if self.is_system_pose?
      return true if Scenes.can_manage_scenes?(actor)
      return true if actor == self.character
      return true if self.restarted_scene_pose && Scenes.can_edit_scene?(actor, self.scene)
      return false
    end
  end
end
