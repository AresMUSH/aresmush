module AresMUSH
  # Searches for a target (haracter/room/exit) with a given name in the viewer's room.
  # Handles special keywords 'me' and 'here'.
  class VisibleTargetFinder
    # @return [FindResult]
    def self.find(name, viewer)
      name = name.upcase
      return FindResult.new(viewer, nil) if (name == "ME")

      viewer_room = viewer.room
      return FindResult.new(viewer_room, nil) if (name == "HERE")
      
      rooms = viewer_room.name_upcase == name ? [ viewer_room ] : []
      exits = viewer_room.exits.select { |e| e.name_upcase == name }
      chars = viewer_room.characters.select { |c| c.name_upcase == name }
      contents = [chars, exits, rooms].flatten(1)
            
      if (contents.count == 0)
        exits = viewer_room.exits.select { |e| e.name_upcase.start_with?(name) }
        chars = viewer_room.characters.select { |c| c.name_upcase.start_with?(name) }
        rooms = viewer_room.name_upcase == name ? [ viewer_room ] : []
        contents = [chars, exits, rooms].flatten(1)
      end
      
      SingleResultSelector.select(contents)
    end
    
    # @yieldparam model [Character, Room, Exit] The object that was found.
    # @note Failure message will be emitted and block will not run if an object with that name is not found in the room.
    def self.with_something_visible(name, client, viewer, &block)
      result = VisibleTargetFinder.find(name, viewer)
      
      if (!result.found?)
        client.emit_failure(result.error)
        return
      end
      
      yield result.target
    end
  end
end