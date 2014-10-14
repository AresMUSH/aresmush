module AresMUSH
  module Api
    class ApiCommandHandler
      attr_accessor :game_id, :cmd
      
      def initialize(game_id, cmd)
        @game_id = game_id
        @cmd = cmd
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
      attr_accessor :client, :response
      
      def initialize(client, response)
        @client = client
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