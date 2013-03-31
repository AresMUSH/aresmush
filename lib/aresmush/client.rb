module AresMUSH

  class Client 

    attr_reader :ip_addr, :id
    attr_accessor :player
    
    def initialize(id, client_monitor, config_reader, connection)
      @id = id
      @client_monitor = client_monitor
      @connection = connection
      @config_reader = config_reader
    end
    
    def to_s
      "Name=#{name} ID=#{id}"
    end
    
    def connected
      ClientGreeter.greet(self, @config_reader.config['connect'])
    end

    def ping
      @connection.ping
    end
    
    def emit(msg)
      @connection.send_data msg
    end 
    
    def emit_ooc(msg)
      @connection.send_data "%xc%% #{msg}%xn"
    end

    def emit_success(msg)
      @connection.send_data "%xg%% #{msg}%xn"
    end

    def emit_failure(msg)
      @connection.send_data "%xr%% #{msg}%xn"
    end

    # Initiates a disconnect on purpose
    def disconnect
      @connection.close_connection
    end
    
    def handle_input(data)
      @client_monitor.handle_client_input(self, data)
    end

    # Responds to a disconnect from any sort of source - socket error, client-initated, etc.
    def connection_closed
      @client_monitor.connection_closed self
    end
    
    def name
      @player.nil? ? t('client.anonymous'): @player['name']
    end
    
    def location
      @player.nil? ? nil : @player['location']
    end
  end
end