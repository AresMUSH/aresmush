module AresMUSH
  
  module MongoModel
    def self.find(*args)
      db[coll].find(*args).to_a
    end
    
    def self.coll
      raise "Define me!"
    end
    
    
    
  end
  
  module Player
    
    include MongoModel
    
    def self.coll
      :players
    end
    
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
       db[:players].insert(player)
       player 
    end
    
    def self.update(player)
      db[:players].update( { "_id" => player["_id"] }, player)
    end
  end
end
    