module AresMUSH
  module CommonCracks
    def self.arg1_equals_arg2
      /(?<arg1>[^\=]+)\=(?<arg2>.+)/
    end
    
    def self.arg1_equals_optional_arg2
      /(?<arg1>[^\=]+)\=?(?<arg2>.+)?/
    end
    
    def self.arg1_space_arg2
      /(?<arg1>[\S]+) (?<arg2>.+)/
    end
  end
end