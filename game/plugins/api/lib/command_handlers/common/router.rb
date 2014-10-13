module AresMUSH
  module Api
    class ApiRouter
      def route_command(game_id, command_str)
        command = command_str.before(" ")
        args = command_str.after(" ")
      
        Global.logger.debug "API Command: #{game_id} #{command_str}"
        
        cmd, handler = crack_command(game_id, command, args)
        
        if (cmd.nil? || handler.nil?)
          return ApiResponse.create_error_response(cmd, "Unrecognized command.")
        end
        
        error = cmd.validate
        if (error)
          return ApiResponse.create_error_response(cmd, error)
        end
        
        handler.handle(cmd)
      end
      
      def route_response(client, response)
        handler = build_response_handler(client, response)
        if (handler.nil?)
          raise "Unrecognized command."
        end
        
        handler.handle
      end
      
      def crack_command(game_id, command, args)
        raise NotImplementedError
      end
            
      def build_response_handler(game_id, command, args)
        raise NotImplementedError
      end
      
      def send_game_update
        raise NotImplementedError
      end
    end
  end
end