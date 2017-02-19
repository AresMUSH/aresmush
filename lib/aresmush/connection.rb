module AresMUSH

  class Connection < EventMachine::Connection
    attr_accessor :client
    attr_reader :ip_addr
    
    def post_init
      begin
        port, @ip_addr = Socket.unpack_sockaddr_in(get_peername)
      rescue Exception => e
        Global.logger.warn "Could not decode IP address.  error=#{e} backtrace=#{e.backtrace[0,10]}"
        @ip_addr = "0.0.0.0"
      end
    end

    def ping
      send_data ANSI.reset
    end
    
    def send_data(msg)
      begin
        super msg
      rescue Exception => e
        Global.logger.warn "Could not send to connection:  error=#{e} backtrace=#{e.backtrace[0,10]}."
      end
    end
    
    def send_formatted(msg, enable_fansi = true)
      send_data ClientFormatter.format(msg, enable_fansi)
    end
    
    def close_connection(after_writing = false)
      begin
        super
      rescue Exception => e
        Global.logger.warn "Couldn't close connection:  error=#{e} backtrace=#{e.backtrace[0,10]}."
      end
    end
    
    def receive_data(data)
      begin
        input = strip_control_chars(data)
        @client.handle_input(input)
      rescue Exception => e
        Global.logger.warn "Error receiving data:  error=#{e} backtrace=#{e.backtrace[0,10]}."
      end
    end

    def unbind
      begin
        @client.connection_closed
      rescue Exception => e
        Global.logger.warn "Error closing connection:  error=#{e} backtrace=#{e.backtrace[0,10]}."
      end
    end  
    
    private 
    
    def strip_control_chars(data)
      stripped = data.gsub(/\^M/,"\n")
      stripped = stripped.gsub(/\0/,"")
      stripped.gsub(/\^@/,"")
    end   
  end
end