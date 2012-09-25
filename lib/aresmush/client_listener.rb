module AresMUSH

  # This class exists to offload the thread-centric stuff so the controller can be more testable.
  class ClientListener

    def initialize(connection_monitor)
      @connection_monitor = connection_monitor
    end
    
    def start(server)
      # TODO - handle exceptions
      loop {
        @thread = Thread.start(server.accept) do |client|
          @connection_monitor.client_connected(client)
          while line = client.gets 
            @connection_monitor.client_input(client, line)
          end
          @connection_monitor.client_disconnected(client)
        end   
      }   
    end

    def stop
      @thread.exit
    end

  end
end
