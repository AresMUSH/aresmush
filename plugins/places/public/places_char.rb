module AresMUSH
  class Character
    reference :place, "AresMUSH::Place"
    
    def place_name
      self.place ? self.place.name : nil
    end
  end
end