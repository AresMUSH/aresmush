module AresMUSH
  class AnyTargetFinder
    def self.find(name_or_id, char)
      find_result = VisibleTargetFinder.find(name_or_id, char)
      
      if (find_result.found?)
        return find_result
      end
      
      chars = Character.find_all_by_name_or_id(name_or_id)
      exits = Exit.find_all_by_name_or_id(name_or_id)
      rooms = Room.find_all_by_name_or_id(name_or_id)
      
      contents = [chars, exits, rooms].flatten(1).select { |c| c }   
            
      SingleResultSelector.select(contents)
    end
    
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