module AresMUSH
  class VisibleTargetFinder
    def self.find(name, viewer)
      return FindResult.new(viewer, nil) if (name.downcase == "me")

      name = name.downcase
      viewer_room = viewer.room
      return FindResult.new(viewer_room, nil) if (name == "here")
      return FindResult.new(viewer_room, nil) if (viewer_room.name.downcase.start_with?(name))

      exits = viewer_room.exits.select { |e| e.name.downcase.start_with?(name) }
      chars = viewer_room.characters.select { |c| c.name.downcase.start_with?(name) }
      contents = [chars, exits].flatten(1)
                  
      SingleResultSelector.select(contents)
    end
    
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