module AresMUSH
  class ServerInfo
    def self.categories
      ["Historical", "Sci-Fi", "Fantasy", "Modern", "Supernatural", "Social", "Other"]
    end
    
    field :game_id, :type => Integer, :default => default_game_id
    field :name, :type => String
    field :description, :type => String
    field :host, :type => String
    field :port, :type => Integer
    field :category, :type => String
    field :website, :type => String
    field :game_open, :type => String
    field :key, :type => String, :default => default_key
    field :last_ping, :type => Time, :default => Time.now
    
    field :category_upcase, :type => String
    field :name_upcase, :type => String
    
    before_validation :save_upcase_name
    
    def self.next_id
      ServerInfo.all.map { |s| s.game_id }.max + 1
    end
    
    def self.find_by_dest_id(dest_id)
      ServerInfo.where(game_id: dest_id).first
    end
    
    def is_master?
      game_id == ServerInfo.arescentral_game_id
    end
    
    def is_open?
      case game_open
      when "yes", "Yes", "true", "True", "open", "Open"
        true
      else
        false
      end
    end
    
    private
    def save_upcase_name
      self.name_upcase = self.name.nil? ? "" : self.name.upcase
      self.category_upcase = self.category.nil? ? "" : self.category.upcase
    end
  end
end