require 'eventmachine'

module AresMUSH

  class Connection < EventMachine::Connection
    attr_accessor :client
    attr_reader :ip_addr
    
    def post_init
      begin
        port, @ip_addr = Socket.unpack_sockaddr_in(get_peername)
      rescue Exception => e
        logger.warn "Could not decode IP address."
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
        logger.warn "Could not send to connection: #{e}."
      end
    end
    
    def send_formatted(msg)
      send_data Formatter.format_client_output(msg)
    end
    
    def close_connection
      begin
        super
      rescue Exception => e
        logger.debug "Couldn't close connection: #{e}."
      end
    end
    
    def receive_data(data)
      @client.handle_input(data)
    end

    def unbind
      @client.connection_closed
    end     
  end
end