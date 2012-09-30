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
       port, @ip_addr = Socket.unpack_sockaddr_in(get_peername)
     end

     def send_data msg
       super Connection.format_msg(msg)
     end
     
     def receive_data data
       @client.handle_input(data)
     end
     
     def unbind
       @client.connection_closed
     end     
  end
end