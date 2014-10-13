module AresMUSH
  module Api
    class ApiMasterRouter < ApiRouter
      def crack_command(game_id, command, args)
        case command
        when "register"
          cmd = ApiRegisterCmd.create_from(game_id, args)
          handler = MasterRegisterCmdHandler
        when "register/update"
          cmd = ApiRegisterUpdateCmd.create_from(game_id, args)
          handler = RegisterUpdateCmdHandler
        else
          cmd = nil
          handler = nil
        end
        [cmd, handler]
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