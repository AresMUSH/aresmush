module AresMUSH
  module Api
    class ApiSlaveRouter < ApiRouter
      def build_command_handler(game_id, cmd)
        
        case cmd.command_name
        when "register/update"
          handler = RegisterUpdateCmdHandler
        when "unlink"
          handler = Handles::UnlinkCmdHandler
        else
          handler = nil
        end
        handler.nil? ? nil : handler.new(game_id, cmd)
      end
      
      def build_response_handler(client, response)
        case response.command_name
        when "friend/add"
          handler = Friends::FriendResponseHandler
        when "friend/remove"
          handler = Friends::FriendResponseHandler
        when "link"
          handler = Handles::LinkResponseHandler
        when "login"
          handler = LoginResponseHandler
        when "ping"
          handler = NoOpResponseHandler
        when "register"
          handler = SlaveRegisterResponseHandler
        when "register/update"
          handler = RegisterUpdateResponseHandler
        else
          handler = nil
        end
        handler.nil? ? nil : handler.new(client, response)
      end
    end
  end
end