require 'bcrypt'

module AresMUSH
    module Player
    
    extend AresModel
    
    def self.coll
      :players
    end    
    
    # TODO: Find by alias too once alias system is implemented
    
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
    