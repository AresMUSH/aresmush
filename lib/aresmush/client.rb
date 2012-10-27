module AresMUSH

  class Client 

    attr_reader :ip_addr, :id

    def initialize(id, client_monitor, config_reader, connection)
      @id = id
      @client_monitor = client_monitor
      @connection = connection
      @config_reader = config_reader
    end

    def connected
      # Connect screen ansi
      emit @config_reader.txt['connect']

      # Ares welcome text
      emit_ooc t('welcome')

      # Game welcome text.
      emit @config_reader.config['connect']['welcome_text']
    end

    def emit(msg)
      send_data msg
    end 

    def emit_ooc(msg)
      send_data "%xc%% #{msg}%xn"
    end

    def emit_success(msg)
      send_data "%xg%% #{msg}%xn"
    end

    def emit_failure(msg)
      send_data "%xr%% #{msg}%xn"
    end

    def disconnect
      begin
        @connection.close_connection 
      rescue Exception => e
        logger.debug "Couldn't close connection: #{e}."
      end
    end

    def handle_input(data)
      @client_monitor.handle_client_input(self, data)
    end

    def connection_closed
      @client_monitor.connection_closed self
    end

    private 
    def send_data(msg)
      begin
        @connection.send_data msg
      rescue Exception => e
        logger.debug "Couldn't send to connection: #{e}."
      end
    end
  end
end