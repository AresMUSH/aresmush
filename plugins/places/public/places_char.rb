module AresMUSH
  class Character
    reference :place, "AresMUSH::Place"

    def place_title(viewer)
      return "" if !self.place
      Places.place_title(self.place.name, viewer.place == self.place)
    end
  end
end