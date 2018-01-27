module AresMUSH
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
