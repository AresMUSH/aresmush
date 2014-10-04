module AresMUSH
  module Api
    class RegisterUpdateCmdHandler
      def self.handle(cmd)      
        if (cmd.game_id == ServerInfo.default_game_id)
          return "register/update Game has not been registered."
        end
        
        game = Api.find_destination(cmd.game_id)
        if (game.nil?)
          return "register/update Cannot find server info."
        end
        
        Global.logger.info "Updating existing game #{game.game_id} #{cmd.name}."

        game.category = cmd.category
        game.name = cmd.name
        game.description = cmd.desc
        game.host = cmd.host
        game.port = cmd.port
        game.save!
        
        "register/update OK"
      end
    end
  end
end