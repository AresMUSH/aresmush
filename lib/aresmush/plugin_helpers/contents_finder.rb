module AresMUSH
  class ContentsFinder
    def self.find(loc_id)
      # TODO - REDO
      chars = Character.find_by_location_id(loc_id)
      rooms = Room.find_by_location_id(loc_id)
      exits = Exit.find_by_location_id(loc_id)
      [chars, rooms, exits].flatten(1)      
    end
  end
end