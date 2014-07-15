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
    
    def self.arg1_equals_arg2_slash_arg3
      /(?<arg1>[^\=]+)\=(?<arg2>[^\/]+)\/(?<arg3>.+)/
    end
    
    def self.arg1_equals_arg2_slash_optional_arg3
      /(?<arg1>[^\=]+)\=(?<arg2>[^\/]+)\/?(?<arg3>.+)?/
    end
  end
end