module AresMUSH
  class SceneLog < Ohm::Model
    include ObjectModel
    
    attribute :log
    reference :scene, "AresMUSH::Scene"
  end    
end
