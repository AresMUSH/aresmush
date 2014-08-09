require 'eventmachine'

module AresMUSH
  class Server
    
    def start
      EventMachine::run do
        host = Global.config['server']['hostname']
        port = Global.config['server']['port']
        EventMachine::add_periodic_timer(45) do
          Global.client_monitor.clients.each { |c| c.ping }
          Cron.raise_event
        end
        
        EventMachine::start_server(host, port, Connection) do |connection|
          Global.client_monitor.connection_established(connection)
        end
        Global.logger.info "Server started on #{host}:#{port}."
      end
    end   
  end
end
