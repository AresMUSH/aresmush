module AresMUSH
  class SingleResultSelector
    def self.select(results)
      if (results.nil? || results.empty?)
        return FindResult.new(nil, t("db.object_not_found"))
      elsif (results.count > 1)
        return FindResult.new(nil, t("db.object_ambiguous"))
      else
        return FindResult.new(results[0], nil)
      end
    # If someone inadvertently passed a non-array-based item to this, 
    # we want to catch those errors and return nil.
    rescue ArgumentError, NoMethodError
      return FindResult.new(nil, t("db.object_not_found"))        
    end
  end
end