require 'eventmachine'

module AresMUSH
  class Server
    def initialize(config_reader, client_monitor)
      @config_reader = config_reader
      @client_monitor = client_monitor
    end

    def start
      EventMachine::run do
        host = @config_reader.config['server']['hostname']
        port = @config_reader.config['server']['port']
        EventMachine::add_periodic_timer(30) do
          @client_monitor.clients.each { |c| c.ping }
        end
        
        EventMachine::start_server(host, port, Connection) do |connection|
          connection.config_reader = @config_reader
          @client_monitor.connection_established(connection)
        end
        logger.info "Server started on #{host}:#{port}."
      end
    end   
  end
end
