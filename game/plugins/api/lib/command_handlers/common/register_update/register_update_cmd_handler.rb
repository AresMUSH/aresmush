module AresMUSH
  module Api
    class RegisterUpdateCmdHandler
      def self.handle(cmd)      
        if (cmd.game_id == ServerInfo.default_game_id)
          return ApiResponse.create_error_response(cmd, "Game has not been registered.")
        end
        
        game = Api.get_destination(cmd.game_id)
        if (game.nil?)
          return ApiResponse.create_error_response(cmd, "Cannot find server info.")
        end
        
        Global.logger.info "Updating existing game #{game.game_id} #{cmd.name}."

        game.category = cmd.category
        game.name = cmd.name
        game.description = cmd.desc
        game.host = cmd.host
        game.port = cmd.port
        game.save!
        
        ApiResponse.create_ok_response(cmd)
      end
    end
  end
end