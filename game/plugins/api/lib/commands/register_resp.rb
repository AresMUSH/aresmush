module AresMUSH
  module Api
    class ApiRegisterResponse
      attr_accessor :client, :game_id, :key
      
      def initialize(client, response_str)
        @client = client
        args = response_str.split("||")
        @game_id, @key = args
      end
    end
    
    class ApiRegisterResponseHandler
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