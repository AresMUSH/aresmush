module AresMUSH
  module Api
    class ApiSlaveRouter
      def route_command(game_id, command_str)
        command = command_str.before(" ")
        args = command_str.after(" ")
      
        Global.logger.debug "API Command: #{game_id} #{command_str}"
        case command
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
        when "register"
          resp = ApiRegisterResponse.new(client, args)
          SlaveRegisterResponseHandler.handle(resp)
        when "register/update"
          resp = ApiRegisterUpdateResponse.new(client, args)
          RegisterUpdateResponseHandler.handle(resp)
        else
          return "Unrecognized response #{command}."
        end
      end
      
      def send_game_update
        if (Game.master.api_game_id == ServerInfo.default_game_id)
          cmd = ApiRegisterCmd.new(
          Game.master.api_game_id,
          server['hostname'], 
          server['port'], 
          server['name'], 
          server['category'],
          server['description'])
        else
          cmd = ApiRegisterUpdateCmd.new(
          Game.master.api_game_id,
          server['hostname'], 
          server['port'], 
          server['name'], 
          server['category'],
          server['description'])
        end
        Api.send_command(ServerInfo.arescentral_game_id, nil, cmd.build_command_str)
      end
    end
  end
end