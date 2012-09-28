module AresMUSH

  # This class exists to offload the thread-centric stuff so the controller can be more testable.
  class ClientListener

    def initialize(connection_monitor, client_factory)
      @connection_monitor = connection_monitor
      @client_factory = client_factory
    end
    
    def start(server)
      # TODO - handle exceptions
      loop {
        @thread = Thread.start(server.accept) do |session|
          client = @client_factory.new_client(session)
          @connection_monitor.client_connected(client)
          
          while line = session.gets 
            client.input(line)
          end
          client.disconnect
        end   
      }   
    end

    def stop
      @thread.exit
    end

  end
end
