module AresMUSH
  class ContentsFinder
    def self.find(loc_id)
      chars = Character.find_by_location(loc_id)
      rooms = Room.find_by_location(loc_id)
      exits = Exit.find_by_location(loc_id)
      [chars, rooms, exits].flatten(1)      
    end
  end
end