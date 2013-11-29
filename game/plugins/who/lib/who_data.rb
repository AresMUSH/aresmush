module AresMUSH
  class WhoData
    def initialize(clients)
      @clients = clients
    end
    
    def online_total
      count = @clients.count
      "#{count} Online"
    end
    
    def ic_total
      count = @clients.count == 0 ? 0 : @clients.count / 2
      "#{count} IC"
    end
    
    def online_record
      "25 Record"
    end
    
    def mush_name
      "AresMUSH"
    end
  end
  
  class WhoCharData
    def initialize(client)
      @client = client
      @char = client.char
    end
    
    def name
      @char["name"]
    end
    
    def position
      "Coder"
    end
    
    def status
      "IC"
    end
    
    def faction
      "Blue"
    end
    
    def idle
      @client.idle
    end    
  end
end