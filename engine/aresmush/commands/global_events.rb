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
    attr_accessor :client, :char_id
    
    def initialize(client, char_id)
      self.client = client
      self.char_id = char_id
    end
  end

  class CharConnectedEvent
    # Note! client may be nil for web-only connection
    attr_accessor :client, :char_id
    
    def initialize(client, char_id)
      self.client = client
      self.char_id = char_id
    end
  end
  
  class CharCreatedEvent
    attr_accessor :client, :char_id
    
    ## NOTE!  Client may be nil
    def initialize(client, char_id)
      self.client = client
      self.char_id = char_id
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