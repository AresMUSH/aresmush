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
      
      def crack_response(client, command, args)        
        case command
        when "register/update"
          response = ApiRegisterUpdateResponse.new(client, args)
          handler = RegisterUpdateResponseHandler
        else
          response = nil
          handler = nil
        end
        
        [response, handler]
      end

      def send_game_update(server_config)
        # TODO - if master, send update to all games
        puts "NOT IMPLEMENTED"
      end
    end
  end
end