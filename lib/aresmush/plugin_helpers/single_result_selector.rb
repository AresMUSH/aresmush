module AresMUSH
  class FindResult
    attr_accessor :found, :target, :error
    def initialize(target, error = nil)
      @target = target
      @error = error
    end
    
    def found?
      !@target.nil?
    end
  end
  
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