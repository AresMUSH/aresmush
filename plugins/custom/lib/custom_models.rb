module AresMUSH
  class MedalAward < Ohm::Model
    reference :character, "AresMUSH::Character"
    attribute :award
    attribute :citation
  end
  
  class Character
    collection :awards, "AresMUSH::MedalAward"
  end
  
  class Game
      attribute :ship_condition
  end
  
  class VictoryKill < Ohm::Model
    reference :character, "AresMUSH::Character"
    reference :scene, "AresMUSH::Scene"   
    attribute :victory 
  end
  
  class Character
    collection :kills, "AresMUSH::VictoryKill"
  end
  
end