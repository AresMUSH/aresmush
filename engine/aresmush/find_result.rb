module AresMUSH
  class FindResult
    attr_accessor :target, :error
    def initialize(target, error = nil)
      @target = target
      @error = error
    end
    
    def found?
      @target
    end
  end
end