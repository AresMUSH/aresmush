module AresMUSH
  module Api
    class PingCmdHandler < ApiCommandHandler
      
      def handle
        game = Api.get_destination(game_id)
        if (game.nil?)
          return cmd.create_error_response("Cannot find server info.")
        end
        
        game.last_ping = Time.now
        game.save!
        
        cmd.create_ok_response
      end
    end
  end
end