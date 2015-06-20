module AresMUSH
  class InputFormatter
    def self.trim_input(arg)
      return nil if arg.nil?
      return arg.strip
    end
    
    def self.titleize_input(arg)
      return nil if arg.nil?
      return arg.strip.titleize
    end
  end
end