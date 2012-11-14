module AresMUSH
  class Player
    
    def self.find(*args)
      player = db[:players].find(*args).to_a
      player.empty? ? nil : player
    end
    
    # Should be case insensitive (Bob bob)
    def self.find_by_name(name)
      find("name" => name)
    end
    
    def self.create(name, password)
      player = 
       {
         "name"     => name,
         "password" => password,
       }
       player["id"] = db[:players].insert(player)
       player 
    end
  end
end
    