module AresMUSH
  class ClassTargetFinder
    def self.find(name_or_id, search_klass)
      results = search_klass.find_all_by_name_or_id(name_or_id)
      SingleResultSelector.select(results)
    end
    
    def self.with_a_character(name_or_id, client, &block)
      result = ClassTargetFinder.find(name_or_id, Character)
      
      if (!result.found?)
        client.emit_failure(result.error)
        return
      end
      
      yield result.target
    end
  end
end