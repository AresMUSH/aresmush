module AresMUSH
  module Api
    class ApiRouter
      def route_command(game_id, cmd)
        handler = build_command_handler(game_id, command_name, args)
        if handler.nil?
          return ApiResponse.create_error_response(command_name, "Unrecognized command.")
        end
        
        error = handler.validate
        if (error)
          return ApiResponse.create_error_response(command_name, error)
        end
        
        handler.handle
      end
      
      def route_response(client, response)
        handler = build_response_handler(client, response)
        if (handler.nil?)
          raise "Unrecognized command."
        end
        
        error = handler.validate
        if (error)
          raise error
        end
        
        handler.handle
      end
      
      def build_command_handler(game_id, command_name, args)
        raise NotImplementedError
      end
            
      def build_response_handler(client, response)
        raise NotImplementedError
      end
      
      def send_game_update
        raise NotImplementedError
      end
    end
  end
end