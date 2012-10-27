module AresMUSH

  class Connection < EventMachine::Connection
    attr_accessor :client
    attr_reader :ip_addr

    def self.format_msg(msg)
      # Add \n to end if not already there
      if (!msg.end_with?("\n"))
        msg = msg + "\n"
      end
      # Ansify
      msg.to_ansi
    end

    def post_init
      begin
        port, @ip_addr = Socket.unpack_sockaddr_in(get_peername)
      rescue Exception => e
        logger.warn "Could not decode IP address."
        @ip_addr = "0.0.0.0"
      end
    end

    def send_data(msg)
      begin
        super Connection.format_msg(msg)
      rescue Exception => e
        logger.warn "Could not send to connection: #{e}."
      end
    end
    
    def close_connection
      begin
        super
      rescue Exception => e
        logger.debug "Couldn't close connection: #{e}."
      end
    end
    
    def receive_data data
      @client.handle_input(data)
    end

    def unbind
      @client.connection_closed
    end     
  end
end