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
    attr_accessor :client, :char
    
    def initialize(client)
      # TODO
      self.char = client.char  
      self.client = client
    end
  end

  class CharConnectedEvent
    attr_accessor :client, :char
    
    def initialize(client)
      # TODO
      self.char = client.char
      self.client = client
    end
  end
  
  class CronEvent
    attr_accessor :time
    
    def initialize(time)
      self.time = time
    end
  end
  
  class GameStartedEvent
  end
  
  class ConfigUpdatedEvent
  end
end