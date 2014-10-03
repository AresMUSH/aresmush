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
          ApiRegisterCmdHandlerMaster.handle(cmd)
        else
          return "Unrecognized command #{command}."
        end
      end
      
      def route_response(client, response_str)
        command = response_str.before(" ")
        args = response_str.after(" ")
        
        case command
        when "register"
          resp = ApiRegisterResponse.new(client, args)
          ApiRegisterResponseHandlerMaster.handle(resp)
        else
          return "Unrecognized command #{command}."
        end
      end
    end
  end
end