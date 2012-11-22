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
      emit_ooc t('welcome')

      # Game welcome text.
      emit @config_reader.config['connect']['welcome_text']
    end

    def emit(msg)
      @connection.send_data msg
    end 

    def emit_with_lines(msg)
      line = @config_reader.line
      @connection.send_data "#{line}\n#{msg.chomp}\n#{line}"
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

    def disconnect
      @connection.close_connection
    end

    def handle_input(data)
      @client_monitor.handle_client_input(self, data)
    end

    def connection_closed
      @client_monitor.connection_closed self
    end
        
  end
end