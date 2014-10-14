module AresMUSH
  module Api
    class ApiSlaveRouter < ApiRouter
      def build_command_handler(game_id, command_name, args)
        
        case command_name
        when "register/update"
          handler = RegisterUpdateCmdHandler.new(game_id, command_name, args)
        else
          handler = nil
        end
        handler
      end
      
      def build_response_handler(client, response)
        case response.command_name
        when "register"
          handler = SlaveRegisterResponseHandler.new(client, response)
        when "register/update"
          handler = RegisterUpdateResponseHandler.new(client, response)
        else
          handler = nil
        end
        handler
      end
      
      def send_game_update(server_config)
        if (Game.master.api_game_id == ServerInfo.default_game_id)
          args = ApiRegisterCmdArgs.new(
          Game.master.api_game_id,
          server_config['hostname'], 
          server_config['port'], 
          server_config['name'], 
          server_config['category'],
          server_config['description'])
        else
          cmd = ApiRegisterCmdArgs.new(
          Game.master.api_game_id,
          server_config['hostname'], 
          server_config['port'], 
          server_config['name'], 
          server_config['category'],
          server_config['description'])
        end
        Api.send_command(ServerInfo.arescentral_game_id, nil, cmd.build_command_str)
      end
    end
  end
end