module AresMUSH

  # Special class used specifically for actions coming from the website, where we need to 
  # fake out having a client connection.
  class HeadlessConnection
    attr_accessor :client, :ip_addr
    
    def initialize(ip)
      self.ip_addr = ip
    end
    
    def ping
    end
    
    def send_data(msg)
    end
    
    def send_formatted(msg, enable_fansi = false)
    end
    
    def connection_closed
    end
    
    def close_connection(dummy = nil)
    end
    
    def receive_data(data)
    end
  end
end