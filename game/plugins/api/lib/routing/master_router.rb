module AresMUSH
  module Api
    class ApiMasterRouter < ApiRouter
      def build_command_handler(game_id, cmd)
        case cmd.command_name
        when "register"
          handler = MasterRegisterCmdHandler
        when "register/update"
          handler = RegisterUpdateCmdHandler
        when "ping"
          handler = PingCmdHandler
        else
          handler = nil
        end
        handler.nil? ? nil : handler.new(game_id, cmd)
      end
      
      def build_response_handler(client, response)  
        case response.command_name
        when "register/update"
          handler = RegisterUpdateResponseHandler
        else
          handler = nil
        end
        handler.nil? ? nil : handler.new(client, response)
      end

      def send_game_update(server_config)
        ServerInfo.all.each do |s|
          next if (s.game_id == Game.master.api_game_id)
          
          args = ApiRegisterCmdArgs.new(server_config["hostname"], 
            server_config["port"], 
            server_config["name"], 
            server_config["category"], 
            server_config["description"])
            
          cmd = ApiCommand.new("register/update", args.to_s)
          Api.send_command(s.game_id, nil, cmd)
        end
      end
    end
  end
end