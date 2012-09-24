require 'socket'
require "ansi"

module AresMUSH

  class ServerController

    def initialize(server, config_reader, client_listener)
      @server = server
      @client_listener = client_listener
      @config_reader = config_reader
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
      port = @config_reader.config['server']['port']
      puts "Listening for messages on port #{port}."
      @client_listener.start(@server, self)
    end

    def client_connected(client)
      # TODO
      puts client.addr
      client.puts ANSI.red  + @config_reader.config['connect']['welcome_text'] + ANSI.reset + "Hello"
      connect_text = @config_reader.txt['connect']
      connect_text = connect_text.gsub(/%cr/, ANSI.red)
      connect_text = connect_text.gsub(/%cn/, ANSI.reset)
      client.puts connect_text
    end

    def client_disconnected(client)
      puts "Client disconnected " + client.addr
      # TODO
    end
    
    def client_input(client, line)
      # TODO
      puts line         
      client.puts("You typed: #{line}")
    end

  end
end
