module AresMUSH

  class Client < EventMachine::Connection

    def self.next_id
      @@next_id ||= 0
      @@next_id = @@next_id + 1
    end

    def self.format_msg(msg)
      # Add \n to end if not already there
      if (!msg.end_with?("\n"))
        msg = msg + "\n"
      end
      
      # Ansify
      msg.to_ansi
    end
    
    def emit(msg)
      send_data Client.format_msg(msg)
    end 

    attr_reader :id, :ip_addr

    def post_init
      @id = Client.next_id
      @port, @ip_addr = Socket.unpack_sockaddr_in(get_peername)
      Bootstrapper.client_monitor.add_client(self)
    end

    def receive_data data
      if data =~ /quit/i
        close_connection 
      else
        Bootstrapper.client_monitor.tell_all "Client #{id} says #{data}"
      end
    end

    def unbind
      Bootstrapper.client_monitor.rm_client self
    end

  end
end