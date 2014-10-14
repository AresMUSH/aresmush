module AresMUSH
  module Api
    class ApiMasterRouter < ApiRouter
      def build_command_handler(game_id, command_name, args)
        case command_name
        when "register"
          handler = MasterRegisterCmdHandler.new(game_id, command_name, args)
        when "register/update"
          handler = RegisterUpdateCmdHandler.new(game_id, command_name, args)
        else
          handler = nil
        end
        handler
      end
      
      def build_response_handler(client, response)  
        case response.command_name
        when "register/update"
          handler = RegisterUpdateResponseHandler.new(client, response)
        else
          handler = nil
        end
        handler
      end

      def send_game_update(server_config)
        # TODO - if master, send update to all games
        puts "NOT IMPLEMENTED"
      end
    end
  end
end