module AresMUSH
  module Api
    class ApiSlaveRouter < ApiRouter
      def build_command_handler(game_id, cmd)
        
        case cmd.command_name
        when "register/update"
          handler = RegisterUpdateCmdHandler
        else
          handler = nil
        end
        handler.nil? ? nil : handler.new(game_id, cmd)
      end
      
      def build_response_handler(client, response)
        case response.command_name
        when "register"
          handler = SlaveRegisterResponseHandler
        when "register/update"
          handler = RegisterUpdateResponseHandler
        when "ping"
          handler = PingResponseHandler
        when "friend/add"
          handler = FriendResponseHandler
        when "friend/remove"
          handler = FriendResponseHandler
        else
          handler = nil
        end
        handler.nil? ? nil : handler.new(client, response)
      end
      
      def send_game_update(server_config)
        args = ApiRegisterCmdArgs.new(
          server_config['hostname'], 
          server_config['port'], 
          server_config['name'], 
          server_config['category'],
          server_config['description'])

        if (Game.master.api_game_id == ServerInfo.default_game_id)
          cmd = ApiCommand.new("register", args.to_s)
        else
          cmd = ApiCommand.new("register/update", args.to_s)
        end
        Api.send_command(ServerInfo.arescentral_game_id, nil, cmd)
      end
    end
  end
end