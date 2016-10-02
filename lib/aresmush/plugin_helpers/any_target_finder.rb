module AresMUSH
  class AnyTargetFinder
    def self.find(name_or_id, client)
      find_result = VisibleTargetFinder.find(name_or_id, client)
      
      if (find_result.found?)
        return find_result
      end
      
      chars = Character.find_any(name_or_id)
      exits = Exit.find_any(name_or_id)
      rooms = Room.find_any(name_or_id)
      
      contents = [chars, exits, rooms].flatten(1).select { |c| !c.nil? }   
            
      SingleResultSelector.select(contents)
    end
    
    def self.with_any_name_or_id(name, client, &block)
      result = AnyTargetFinder.find(name, client)
      
      if (!result.found?)
        client.emit_failure(result.error)
        return
      end
      
      yield result.target
    end
  end
end