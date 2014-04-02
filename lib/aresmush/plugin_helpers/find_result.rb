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
end