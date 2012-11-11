module AresMUSH
  module Addon
    def initialize(container)
      @container = container
      after_initialize
    end
    
    attr_reader :container
    
    # Override this with any custom initialization
    def after_initialize
    end
    
    # Override this with an hash of  command => argument regex
    #    TODO: Better docs
    #    "create (?<name>\\S+) (?<password>\\S+)"
    def commands
      nil
    end

  end
end