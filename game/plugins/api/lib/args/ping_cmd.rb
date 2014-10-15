module AresMUSH
  module Api
    class ApiPingCmdArgs
      # List of name:handle
      attr_accessor :chars
      
      def initialize(chars)
        self.chars = chars
      end
      
      def to_s
        chars.join("||")
      end
     
      def self.create_from(command_args)
        chars = command_args.split("||")
        ApiPingCmdArgs.new(chars)
      end
    end
  end
end