module AresMUSH
  class SceneLink < Ohm::Model
    reference :log1, "AresMUSH::Scene"
    reference :log2, "AresMUSH::Scene"
    
    index :log1
    index :log2
  end
end