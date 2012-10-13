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
      connect_text = @config_reader.txt['connect']
      server_welcome_text = _t('welcome')
      game_welcome_text = @config_reader.config['connect']['welcome_text']
      emit connect_text
      emit "%xg#{server_welcome_text}%xn"
      emit game_welcome_text
    end
    
    def emit(msg)
      @connection.send_data msg
    end 
    
    def disconnect
      @connection.close_connection 
    end
    
    def handle_input(data)
      @client_monitor.handle(self, data)
    end

    def connection_closed
      @client_monitor.connection_closed self
    end

  end
end