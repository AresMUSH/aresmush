module AresMUSH
  module Api
    class ApiMasterRouter
      def route_command(game_id, command_str)
        command = command_str.before(" ")
        args = command_str.after(" ")
      
        Global.logger.debug "API Command: #{game_id} #{command_str}"
        case command
        when "register"
          cmd = ApiRegisterCmd.create_from(game_id, args)
          MasterRegisterCmdHandler.handle(cmd)
        when "register/update"
          cmd = ApiRegisterUpdateCmd.create_from(game_id, args)
          RegisterUpdateCmdHandler.handle(cmd)
        else
          return "Unrecognized command #{command}."
        end
      end
      
      def route_response(client, response_str)
        command = response_str.before(" ")
        args = response_str.after(" ")
        
        case command
        when "register/update"
          resp = ApiRegisterUpdateResponse.new(client, args)
          RegisterUpdateResponseHandler.handle(resp)
        else
          return "Unrecognized response #{command}."
        end
      end

      def send_game_update(server_config)
        # TODO - if master, send update to all games
        puts "NOT IMPLEMENTED"
      end
    end
  end
end