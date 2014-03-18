module AresMUSH
  class SingleTargetFinder
    def self.find(name_or_id, search_klass)
      results = search_klass.where( { :$or => [ { :name => name_or_id }, { :id => name_or_id } ] } ).all
      SingleResultSelector.select(results)
    end
  end
end