module AresMUSH

  class Client 

    attr_reader :ip_addr, :id
    
    def initialize(id, client_monitor, config_reader, connection)
      @id = id
      @client_monitor = client_monitor
      @connection = connection
      @config_reader = config_reader
    end
    
    def format_msg(msg)
      # Add \n to end if not already there
      if (!msg.end_with?("\n"))
        msg = msg + "\n"
      end
      # Ansify
      msg.to_ansi
    end
    
    def connected
      connect_text = @config_reader.txt['connect']
      emit connect_text
      emit @config_reader.config['connect']['welcome_text']
    end
    
    def emit(msg)
      @connection.send_data format_msg(msg)
    end 
    
    def handle_input(data)
      # TODO - pass on to command modules.
      if data =~ /quit/i
         @connection.close_connection 
       else
         @client_monitor.tell_all "Client #{id} says #{data}"
       end
    end

    def connection_closed
      @client_monitor.connection_closed self
    end

  end
end