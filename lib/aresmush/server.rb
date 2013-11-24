require 'eventmachine'

module AresMUSH
  class Server
    def initialize(client_monitor)
      @client_monitor = client_monitor
    end

    def start
      EventMachine::run do
        host = Global.config['server']['hostname']
        port = Global.config['server']['port']
        EventMachine::add_periodic_timer(30) do
          @client_monitor.clients.each { |c| c.ping }
        end
        
        EventMachine::start_server(host, port, Connection) do |connection|
          @client_monitor.connection_established(connection)
        end
        Global.logger.info "Server started on #{host}:#{port}."
      end
    end   
  end
end
