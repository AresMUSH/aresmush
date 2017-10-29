module AresMUSH
  class ClassTargetFinder
    def self.find(name_or_id, search_klass, viewer)
      if (viewer)
        return FindResult.new(viewer, nil) if (name_or_id.downcase == "me") && search_klass == Character
        return FindResult.new(viewer.room, nil) if (name_or_id.downcase == "here") && search_klass == Room
      end
      
      results = search_klass.find_any_by_name(name_or_id)      
      SingleResultSelector.select(results)
    end
    
    def self.with_a_character(name_or_id, client, viewer, &block)
      result = ClassTargetFinder.find(name_or_id, Character, viewer)
      
      if (!result.found?)
        client.emit_failure(result.error)
        return
      end
      
      yield result.target
    end
  end
end