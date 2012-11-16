module AresMUSH
  class Player
    
    def self.find(*args)
      db[:players].find(*args).to_a
    end
    
    def self.find_by_name(name)
      find("name_upcase" => name.upcase)
    end
    
    def self.create(name, password)
      player = 
       {
         "name"       => name,
         "name_upcase" => name.upcase,
         "password"   => password,
       }
       player["id"] = db[:players].insert(player)
       player 
    end
  end
end
    