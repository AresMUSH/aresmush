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

    def connected
      # Connect screen ansi
      emit @config_reader.config['connect']['welcome_screen']

      # Ares welcome text
      emit_ooc t('client.welcome')

      # Game welcome text.
      emit @config_reader.config['connect']['welcome_text']
    end

    def ping
      @connection.ping
    end
    
    def disconnected
      emit_ooc t('client.goodbye')
    end
    
    def emit(msg)
      @connection.send msg
    end 
    
    def emit_ooc(msg)
      @connection.send "%xc%% #{msg}%xn"
    end

    def emit_success(msg)
      @connection.send "%xg%% #{msg}%xn"
    end

    def emit_failure(msg)
      @connection.send "%xr%% #{msg}%xn"
    end

    def disconnect
      @connection.close_connection
    end

    def handle_input(data)
      @client_monitor.handle_client_input(self, data)
    end

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