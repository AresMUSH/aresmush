require 'eventmachine'

module AresMUSH

  class CommandLine

    def initialize(config_reader, client_monitor)
      @config_reader = config_reader
      @client_monitor = client_monitor
    end
    
    def start
      EventMachine::run do
        host = 'localhost'
        port = @config_reader.config['server']['port']
        EventMachine::start_server(host, port, Connection) do |connection|
          @client_monitor.connection_established(connection)
        end
        puts "Started MuServer on #{host}:#{port}..."
      end
    end
  end
end