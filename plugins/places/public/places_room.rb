module AresMUSH
  class Room
    collection :places, "AresMUSH::Place"
    
    before_delete :clear_places
    
    def clear_places
      self.places.each { |e| e.delete }
    end
    
  end
end