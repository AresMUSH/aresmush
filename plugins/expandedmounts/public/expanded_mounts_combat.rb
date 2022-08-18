module AresMUSH
  class Combat < Ohm::Model
    collection :mounts, "AresMUSH::Mount"
  end
end