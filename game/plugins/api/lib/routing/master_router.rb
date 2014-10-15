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
        # TODO - if master, send update to all games
        puts "NOT IMPLEMENTED"
      end
    end
  end
end