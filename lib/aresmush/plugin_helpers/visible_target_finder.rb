module AresMUSH
  class VisibleTargetFinder
    def self.find(name, client)
      return FindResult.new(client.char, nil) if (name.downcase == "me")
      return FindResult.new(client.room, nil) if (name.downcase == "here")

      chars = Character.find_by_room_id_and_name_upcase(client.room.id, name.upcase)
      exits = Exit.find_by_source_id_and_name_upcase(client.room.id, name.upcase)
      contents = [chars, exits].flatten(1).select { |c| !c.nil? }   
            
      SingleResultSelector.select(contents)
    end
  end
end