module AresMUSH
  module Api
    class ApiRegisterResponseHandlerSlave
      def self.handle(response)
        Global.logger.info "API info updated."
        
        game = Game.master
        game.api_game_id = response.game_id
        game.save

        central = Api.get_destination(ServerInfo.arescentral_game_id)
        if (game.nil?)
          raise "Can't find AresCentral server info."
        end
        central.key = response.key
        central.save
      end
    end
  end
end