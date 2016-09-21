module AresMUSH
  module Api
    def self.update_game
      Global.logger.info "Updating game registration."
      params = Api.build_game_params
      connector = AresCentral::AresConnector.new
      response = connector.update_game(params)
    
      if (response.is_success?)
        Global.logger.info "Game registration updated."
      else
        raise "Response failed: #{response}"
      end
    end
    
    def self.register_game
      Global.logger.info "Creating game registration."
      params = Api.build_game_params
      connector = AresCentral::AresConnector.new    
      response = connector.register_game(params)
      
      if (response.is_success?)
        game = Game.master
        game.api_key = response.data["api_key"]
        game.api_game_id = response.data["game_id"]
        game.save!
        Global.logger.info "Game registration created."
      else
        raise "Response failed: #{response}"
      end
    end
    
    def self.build_game_params
      server_config = Global.read_config("server")
      game_config = Global.read_config("game")
    
      params = {
        host: server_config['hostname'], 
        port: server_config['port'], 
        name: game_config['name'], 
        category: game_config['category'],
        description: game_config['description'],
        website: game_config["website"],
        public_game: game_config["public_game"]
      }
      
      params
    end   
  end
end
