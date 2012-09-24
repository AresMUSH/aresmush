module AresMUSH

  # This class exists to offload the thread-centric stuff so the controller can be more testable.
  class ClientListener

    def start(server, controller)
      # TODO - handle exceptions
      loop {
        @thread = Thread.start(server.accept) do |client|
          controller.client_connected(client)
          while line = client.gets 
            controller.client_input(client, line)
          end
          controller.client_disconnected(client)
        end   
      }   
    end

    def stop
      @thread.exit
    end

  end
end
