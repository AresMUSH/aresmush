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
    
    def self.categories
      ["Historical", "Sci-Fi", "Fantasy", "Modern", "Supernatural", "Social", "Other"]
    end
    
    field :game_id, :type => Integer, :default => default_game_id
    field :name, :type => String
    field :description, :type => String
    field :host, :type => String
    field :port, :type => Integer
    field :category, :type => String
    field :key, :type => String, :default => default_key
    field :last_ping, :type => Time, :default => Time.now
    
    def self.next_id
      ServerInfo.all.map { |s| s.game_id }.max + 1
    end
  end
end