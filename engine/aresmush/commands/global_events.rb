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
  
  class WebCmdEvent
    
    attr_accessor :client, :cmd_name, :data
    
    def initialize(client, cmd_name, data)
      self.client = client
      self.cmd_name = cmd_name
      self.data = data
    end
  end
end