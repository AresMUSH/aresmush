module AresMUSH
  # Searches for objects of the specified class (usually Character/Room?Exit but any db model supporting)
  # FindByName can be used. Allows special keywords 'me' and 'here'.
  class ClassTargetFinder
    # @return [FindResult]
    def self.find(name_or_id, search_klass, viewer)
      if (viewer)
        return FindResult.new(viewer, nil) if (name_or_id.downcase == "me") && search_klass == Character
        return FindResult.new(viewer.room, nil) if (name_or_id.downcase == "here") && search_klass == Room
      end
      
      results = search_klass.find_any_by_name(name_or_id)      
      SingleResultSelector.select(results)
    end
    
    # @yieldparam model [Character]
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