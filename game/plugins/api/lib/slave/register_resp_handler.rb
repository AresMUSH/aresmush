module AresMUSH
  module Api
    class ApiRegisterResponseHandlerSlave
      def self.handle(response)
        Global.logger.info "API info updated."
        
        game = Game.master
        game.api_game_id = response.game_id
        game.api_key = response.key
        game.save
      end
    end
  end
end