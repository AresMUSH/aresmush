module AresMUSH
  # Searches objects (Characters/Exits/Rooms) by name or ID.
  class AnyTargetFinder
    # @return [FindResult]
    def self.find(name_or_id, char)
      find_result = VisibleTargetFinder.find(name_or_id, char)
      
      if (find_result.found?)
        return find_result
      end
      
      chars = Character.find_any_by_name(name_or_id)
      exits = Exit.find_any_by_name(name_or_id)
      rooms = Room.find_any_by_name(name_or_id)
      
      contents = [chars, exits, rooms].flatten(1).select { |c| c }   
            
      SingleResultSelector.select(contents)
    end
    
    # @yieldparam model [Character, Room, Exit]
    def self.with_any_name_or_id(name, client, char, &block)
      result = AnyTargetFinder.find(name, char)
      
      if (!result.found?)
        client.emit_failure(result.error)
        return
      end
      
      yield result.target
    end
  end
end