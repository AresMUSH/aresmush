module AresMUSH
  class Character
    reference :bonded, "AresMUSH::Mount"

    def is_mount?
      false
    end
  end
end