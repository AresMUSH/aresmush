module AresMUSH
  class AnyTargetFinder
    def self.find(name_or_id, client)
      return FindResult.new(client.char, nil) if (name_or_id.downcase == "me")
      return FindResult.new(client.room, nil) if (name_or_id.downcase == "here")

      chars = Character.find_all_by_name_or_id(name_or_id)
      exits = Exit.find_all_by_name_or_id(name_or_id)
      rooms = Room.find_all_by_name_or_id(name_or_id)
      
      contents = [chars, exits, rooms].flatten(1).select { |c| !c.nil? }   
            
      SingleResultSelector.select(contents)
    end
  end
end