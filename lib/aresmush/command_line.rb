require 'eventmachine'

module AresMUSH

  class CommandLine

    def initialize(config_reader)
      @config_reader = config_reader
    end
    
    def start
      EventMachine::run do
        host = 'localhost'
        port = @config_reader.config['server']['port']
        EventMachine::start_server host, port, Client
        puts "Started MuServer on #{host}:#{port}..."
      end
    end
  end
end