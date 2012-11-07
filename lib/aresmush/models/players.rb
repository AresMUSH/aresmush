module AresMUSH
  class Players
    def self.find(name)
      player = db[:players].find(:name => name).to_a
      player.empty? ? nil : player
    end
    
    def self.create(name, password)
      player = 
       {
         :name     => name,
         :password => password,
       }
       db[:players].insert(player)
    end
  end
end
    