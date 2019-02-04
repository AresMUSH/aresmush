module AresMUSH
  module AresCentral
    def self.is_public_game?
      is_public = Global.read_config("game", "public_game")
      return "#{is_public}".to_bool      
    end
    
    def self.update_game
      return if !AresCentral.is_registered?
      
      Global.logger.info "Updating game registration."
      params = AresCentral.build_game_params
      
      connector = AresCentral::AresConnector.new
      response = connector.update_game(params)
          
      if (response.is_success?)
        Global.logger.info "Game registration updated."
      else
        raise "Response failed: #{response}"
      end
    end
    
    def self.register_game
      return if AresCentral.is_registered?
      
      Global.logger.info "Creating game registration."
      params = AresCentral.build_game_params
      
      connector = AresCentral::AresConnector.new    
      response = connector.register_game(params)
      
      if (response.is_success?)
        game = Game.master
        game.update(api_key: response.data["api_key"])
        game.update(api_game_id: response.data["game_id"])
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
        website: game_config["website"] || Game.web_portal_url,
        public_game: AresCentral.is_public_game?,
        status: game_config["status"],
        activity: Game.master.login_activity
      }
            
      params
    end   
  end
end
