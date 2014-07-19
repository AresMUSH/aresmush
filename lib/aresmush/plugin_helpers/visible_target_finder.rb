module AresMUSH
  class VisibleTargetFinder
    def self.find(name, client)
      return FindResult.new(client.char, nil) if (name.downcase == "me")
      return FindResult.new(client.room, nil) if (name.downcase == "here")

      chars = Character.find_all_by_name(name).select { |c| c.room == client.room }
      exits = Exit.find_all_by_name(name).select { |c| c.source == client.room }
      contents = [chars, exits].flatten(1).select { |c| !c.nil? }   
            
      SingleResultSelector.select(contents)
    end
    
    def self.with_something_visible(name, client, &block)
      result = VisibleTargetFinder.find(name, client)
      
      if (!result.found?)
        client.emit_failure(result.error)
        return
      end
      
      yield result.target
    end
  end
end