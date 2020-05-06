module AresMUSH
  class InputFormatter
    def self.trim_arg(arg)
      return nil if !arg
      return arg.strip
    end
    
    def self.titlecase_arg(arg)
      return nil if !arg
      return arg.strip.titlecase
    end
  end
end