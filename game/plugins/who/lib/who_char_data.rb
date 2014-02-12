module AresMUSH  
  class WhoCharData
    include ToLiquidHelper
    
    def initialize(client)
      @client = client
      @char = client.char
    end
    
    def name
      @char.name
    end
    
    def position
      @char.position
    end
    
    def status
      @char.status
    end
    
    def faction
      @char.faction
    end
    
    def idle
      @client.idle
    end   
    
    def room
      @char.who_location
    end    
    
    def self.sort(clients)
      clients.sort_by{ |c| [c.char.who_location, c.char.name] }
    end 
  end
end