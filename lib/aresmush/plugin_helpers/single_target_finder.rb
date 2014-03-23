module AresMUSH
  class SingleTargetFinder
    def self.find(name_or_id, search_klass)
      results = search_klass.where( { :$or => [ { :name_upcase => name_or_id.upcase }, { :id => name_or_id } ] } ).all
      SingleResultSelector.select(results)
    end
  end
end