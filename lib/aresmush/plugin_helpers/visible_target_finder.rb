module AresMUSH
  class VisibleTargetFinder
    def self.find(name, viewer)
      return FindResult.new(viewer, nil) if (name.downcase == "me")

      viewer_room = viewer.room
      return FindResult.new(viewer_room, nil) if (name.downcase == "here")

      chars = Character.find_any(name).select { |c| c.room == viewer_room }
      exits = Exit.find_any(name).select { |c| c.source == viewer_room }
      contents = [chars, exits].flatten(1).select { |c| c }   
            
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