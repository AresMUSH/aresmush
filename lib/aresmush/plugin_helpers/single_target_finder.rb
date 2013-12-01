module AresMUSH
  class SingleTargetFinder
    def self.find(name_or_id, search_klass)
      results = search_klass.find_by_name_or_id(name_or_id)
      SingleResultSelector.select(results)
    end
  end
end