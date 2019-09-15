module AresMUSH
  class SceneLike < Ohm::Model
    include ObjectModel
    reference :character, "AresMUSH::Character"
    reference :scene, "AresMUSH::Scene"
  end
end