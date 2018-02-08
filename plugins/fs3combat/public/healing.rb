module AresMUSH
  class Healing < Ohm::Model
    reference :character, "AresMUSH::Character"
    reference :patient, "AresMUSH::Character"
  end
end