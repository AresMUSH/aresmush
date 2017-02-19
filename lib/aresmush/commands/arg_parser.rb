module AresMUSH  
  class ArgParser
      
    def self.parse(regex, args)
      match = regex.match(args)
      !match ? HashReader.new({}) : HashReader.new(match.names_hash)
    end
    
    def self.arg1_slash_arg2
      /(?<arg1>[^\/]+)\/(?<arg2>.+)/
    end

    def self.arg1_equals_arg2
      /(?<arg1>[^\=]+)\=(?<arg2>.+)/
    end
    
    def self.arg1_equals_optional_arg2
      /(?<arg1>[^\=]+)\=?(?<arg2>.+)?/
    end
    
    def self.arg1_slash_optional_arg2
      /(?<arg1>[^\/]+)\/?(?<arg2>.+)?/
    end
    
    def self.arg1_space_arg2
      /(?<arg1>[\S]+) (?<arg2>.+)/
    end
    
    def self.arg1_equals_arg2_slash_arg3
      /(?<arg1>[^\=]+)\=(?<arg2>[^\/]+)\/(?<arg3>.+)/
    end

    def self.arg1_slash_arg2_equals_arg3
      /(?<arg1>[^\/]+)\/(?<arg2>[^\/]+)\=(?<arg3>.+)/
    end
    
    def self.arg1_equals_arg2_slash_optional_arg3
      /(?<arg1>[^\=]+)\=(?<arg2>[^\/]+)\/?(?<arg3>.+)?/
    end
    
  end
end