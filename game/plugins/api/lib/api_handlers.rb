module AresMUSH
  module Api
    class ApiCommandHandler
      attr_accessor :game_id, :command_name, :args
      
      def initialize(game_id, command_name, args)
        @game_id = game_id
        @command_name = command_name
        @args = args
        crack!
      end
      
      # Override to set up any custom attributes from the args string
      def crack!
      end
      
      # Override to perform any necessary validation on the command args.
      def validate
      end
    end
    
    class ApiResponseHandler
      attr_accessor :client, :command_name, :response
      
      def initialize(client, command_name, response)
        @client = client
        @command_name = command_name
        @response = response
        crack!
      end
      
      # Override to set up any custom attributes from the args string
      def crack!
      end
      
      # Override to perform any necessary validation on the command args.
      def validate
      end
    end
  end
end