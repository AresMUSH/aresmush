module AresMUSH
  module Api
    
    mattr_accessor :router
    
    def self.create_router
      if (Api.is_master?)
        self.router = ApiMasterRouter.new
      else
        self.router = ApiSlaveRouter.new
      end
    end
    
    def self.is_master?
      game = Game.master
      game.nil? ? false : Game.master.api_game_id == ServerInfo.arescentral_game_id
    end
    
    def self.get_destination(dest_id)
      ServerInfo.where(game_id: dest_id).first
    end
  end
end