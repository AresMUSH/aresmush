require 'socket'

module AresMUSH
    
  class ServerController

    def initialize(server, config)
      @server = server
      @config = config
      @is_started = false
    end

    def started?
      return @is_started
    end
    
    def start      
      if (started?)
        raise "The server is already running."
      end
      port = @config['server']['port']
      puts "Listening for messages on port #{port}."
      @server.open(port) 
      @is_started = true

      #loop {                          # Servers run forever
      #  Thread.start(server.accept) do |client|
      #      client.puts("Welcome #{Time.now.ctime}") # Send the time to the client
      #      while line = client.gets # Read lines from socket
      #        puts line         # and print them
      #        client.puts("You typed: #{line}")
      #      end
      #      
      #  end
      #}

    end
    


  end
end