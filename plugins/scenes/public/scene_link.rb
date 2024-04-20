module AresMUSH
  class SceneLink < Ohm::Model
    reference :log1, "AresMUSH::Scene"
    reference :log2, "AresMUSH::Scene"
    
    index :log1
    index :log2
    
    def self.find_link(scene1, scene2)
      return nil if !scene1
      return nil if !scene2
      
      link = SceneLink.find(log1_id: scene1.id).combine(log2_id: scene2.id).first
      return link if (link)
      
      SceneLink.find(log1_id: scene2.id).combine(log2_id: scene1.id).first      
    end
  end
end