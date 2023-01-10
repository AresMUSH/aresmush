module AresMUSH
  
  class SceneLog < Ohm::Model
    include ObjectModel
    
    reference :scene, "AresMUSH::Scene"
    reference :character, "AresMUSH::Character"
    
    attribute :log
        
    def author_name
      self.character ? self.character.name : "--"
    end
  end    
end
