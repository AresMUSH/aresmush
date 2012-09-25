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
      @client_listener.start(@server)
    end
  end
end
