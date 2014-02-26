module AresMUSH
  # TODO - REDO
  class VisibleTargetFinder
    def self.find(name, client)
      return FindResult.new(client.char, nil) if (name.downcase == "me")

      room = client.room
      if (name.downcase == "here")        
        return FindResult.new(room, nil)
      end

      chars = Character.find_by_room_id_and_name(room.id, name)
      exits = Exit.find_by_source_id_and_name(room.id, name)
      contents = [chars, exits].flatten(1).select { |c| !c.nil? }   
            
      SingleResultSelector.select(contents)
    end
  end
end