module AresMUSH

  class Connection < EventMachine::Connection
     attr_accessor :client
     attr_reader :ip_addr
     
     def post_init
       port, @ip_addr = Socket.unpack_sockaddr_in(get_peername)
     end

     def receive_data data
       @client.handle_input(data)
     end
     
     def unbind
       @client.connection_closed
     end     
  end
end