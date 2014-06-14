module AresMUSH

  class Connection < EventMachine::Connection
    attr_accessor :client
    attr_reader :ip_addr
    
    def post_init
      begin
        port, @ip_addr = Socket.unpack_sockaddr_in(get_peername)
      rescue Exception => e
        Global.logger.warn "Could not decode IP address."
        @ip_addr = "0.0.0.0"
      end
    end

    def ping
      send_data "\0"
    end
    
    def send_data(msg)
      begin
        super msg
      rescue Exception => e
        Global.logger.warn "Could not send to connection: #{e}."
      end
    end
    
    def send_formatted(msg)
      send_data ClientFormatter.format(msg)
    end
    
    def close_connection
      begin
        super
      rescue Exception => e
        Global.logger.debug "Couldn't close connection: #{e}."
      end
    end
    
    def receive_data(data)
      input = strip_control_chars(data)
      @client.handle_input(input)
    end

    def unbind
      @client.connection_closed
    end  
    
    private 
    
    def strip_control_chars(data)
      stripped = data.gsub(/\^M/,"\n")
      stripped.gsub(/\^@/,"")
    end   
  end
end