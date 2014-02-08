module AresMUSH
  class WhoData
    include ToLiquidHelper
    
    def initialize(clients)
      @clients = clients
    end
    
    attr_reader :clients
    
    def online_total
      count = @clients.count
      t('who.players_online', :count => count)
    end
    
    def ic_total
      count = @clients.count == 0 ? 0 : @clients.count / 2
       t('who.players_ic', :count => count)
    end
    
    def online_record
      t('who.online_record', :count => Who.online_record)
    end
    
    def mush_name
      Global.config['server']['mush_name']
    end
  end
  
  class WhoCharData
    include ToLiquidHelper
    
    def initialize(client)
      @client = client
      @char = client.char
    end
    
    def name
      @char["name"]
    end
    
    def position
      @char["position"]
    end
    
    def status
      @char["status"]
    end
    
    def faction
      @char["faction"]
    end
    
    def idle
      @client.idle
    end    
  end
end