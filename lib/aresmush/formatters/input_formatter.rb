module AresMUSH
  class InputFormatter
    def self.trim_input(arg)
      return nil if !arg
      return arg.strip
    end
    
    def self.titleize_input(arg)
      return nil if !arg
      return arg.strip.titleize
    end
  end
end