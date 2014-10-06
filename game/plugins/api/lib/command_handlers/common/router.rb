module AresMUSH
  module Api
    class ApiRouter
      def route_command(game_id, command_str)
        command = command_str.before(" ")
        args = command_str.after(" ")
      
        Global.logger.debug "API Command: #{game_id} #{command_str}"
        
        cmd, handler = crack_command(game_id, command, args)
        
        if (cmd.nil? || handler.nil?)
          return "#{command} Unrecognized command." 
        end
        
        error = cmd.validate
        if (error)
          return "#{command} #{error}"
        end
        
        handler.handle(cmd)
      end
      
      def crack_command(game_id, command, args)
        raise NotImplementedError
      end
      
      def route_response(client, response_str)
        command = response_str.before(" ")
        args = response_str.after(" ")
        
        cmd, handler = crack_response(client, command, args)
        
        if (cmd.nil? || handler.nil?)
          raise "Unrecognized command."
        end
        
        handler.handle(cmd)
      end
      
      def crack_response(game_id, command, args)
        raise NotImplementedError
      end
      
      def send_game_update
        raise NotImplementedError
      end
    end
  end
end