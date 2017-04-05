module AresMUSH
  class Room
    reference :scene, "AresMUSH::Scene"
    attribute :scene_set
  end
  
  class Scene < Ohm::Model
    include ObjectModel
    
    reference :room, "AresMUSH::Room"
    reference :owner, "AresMUSH::Character"
    
    attribute :location
    attribute :private_scene, :type => DataType::Boolean
  end
end