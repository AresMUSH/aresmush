module AresMUSH
  class ConnectionClosedEvent
    attr_accessor :client
      
    def initialize(client)
      self.client = client
    end
  end
    
  class ConnectionEstablishedEvent
    attr_accessor :client
      
    def initialize(client)
      self.client = client
    end
  end
  
  class CharDisconnectedEvent
    attr_accessor :client
    
    def initialize(client)
      self.client = client
    end
  end

  class CharConnectedEvent
    attr_accessor :client
    
    def initialize(client)
      self.client = client
    end
  end
end