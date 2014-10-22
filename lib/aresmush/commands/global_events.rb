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
  
  class UnhandledErrorEvent
    attr_accessor :message
    
    def initialize(message)
      self.message = message
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
  
  class CronEvent
    attr_accessor :time
    
    def initialize(time)
      self.time = time
    end
  end
  
  class ConfigUpdatedEvent
  end
  
  class ApiResponseEvent
    attr_accessor :response, :client

    def initialize(client, response)
      @client = client
      @response = response
    end
  end
end