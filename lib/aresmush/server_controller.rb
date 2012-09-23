require 'socket'

module AresMUSH

  class ServerController

    def initialize(server, config, client_listener)
      @server = server
      @client_listener = client_listener
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
      @is_started = true
      port = @config['server']['port']
      puts "Listening for messages on port #{port}."
      @client_listener.start(@server, self)
    end

    def client_connected(client)
      # TODO      
    end

    def client_input(client, line)
      # TODO
      puts line         
      client.puts("You typed: #{line}")
    end

  end
end
