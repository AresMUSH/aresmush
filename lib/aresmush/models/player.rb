module AresMUSH
  class Player
    
    def self.find(*args)
      player = db[:players].find(*args).to_a
      player.empty? ? nil : player
    end
    
    def self.find_by_name(name)
      find("name_upcase" => name.upcase)
    end
    
    def self.create(name, password)
      player = 
       {
         "name"       => name,
         "name_upase" => name.upcase,
         "password"   => password,
       }
       player["id"] = db[:players].insert(player)
       player 
    end
  end
end
    