require 'bcrypt'

module AresMUSH
    module Player
    
    extend AresModel
    
    def self.coll
      :players
    end    

    def self.create_player(name, raw_password)
      Player.create("name" => name, "password" => Player.hash_password(raw_password))      
    end
    
    def self.exists?(name)
      existing_player = Player.find_by_name(name)
      return !existing_player.empty?
    end
    
    def self.custom_model_fields(model)
      model["name_upcase"] = model["name"].upcase
      model["type"] = "Player"
      model
    end
    
    def self.hash_password(password)
      BCrypt::Password.create(password)
    end
    
    def self.compare_password(player, password)
      hash = BCrypt::Password.new(player["password"])
      hash == password
    end
    
  end
end
    