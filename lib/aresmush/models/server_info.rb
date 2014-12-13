module AresMUSH
  class ServerInfo
    include Mongoid::Document
    include Mongoid::Timestamps
    
    def self.default_key
      "UIEAYPY76718394kJKLjfdoiu6U^MMNH&54dzSW"
    end
    
    def self.default_game_id
      -1
    end
    
    def self.arescentral_game_id
      0
    end
  end
end