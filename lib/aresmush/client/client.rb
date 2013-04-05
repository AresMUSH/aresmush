module AresMUSH

  class Client 

    attr_reader :ip_addr, :id
    attr_accessor :char
    
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
      @connection.send_formatted msg
    end 
    
    def emit_ooc(msg)
      @connection.send_formatted "%xc%% #{msg}%xn"
    end

    def emit_success(msg)
      @connection.send_formatted "%xg%% #{msg}%xn"
    end

    def emit_failure(msg)
      @connection.send_formatted "%xr%% #{msg}%xn"
    end

    def idle
      # TODO - Implement idle command
      "3m"
    end
    
    # Initiates a disconnect on purpose.  Wait a tick
    # to give any pending messages a chance to flush.
    def disconnect
      EM.next_tick { @connection.close_connection }
    end
    
    def handle_input(data)
      @client_monitor.handle_client_input(self, data)
    end

    # Responds to a disconnect from any sort of source - socket error, client-initated, etc.
    def connection_closed
      @client_monitor.connection_closed self
    end
    
    def name
      @char.nil? ? t('client.anonymous'): @char['name']
    end
    
    def location
      @char.nil? ? nil : @char['location']
    end
    
    def logged_in?
      !@char.nil?
    end
  end
end