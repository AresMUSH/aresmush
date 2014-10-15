module AresMUSH
  module Api
    class ApiPingResponseArgs
      # List of name:handle
      attr_accessor :chars
      
      def initialize(chars)
        self.chars = chars
      end
      
      def to_s
        chars.join("||")
      end
     
      def self.create_from(response_args)
        chars = response_args.split("||")
        ApiPingResponseArgs.new(gchars)
      end
    end
  end
end