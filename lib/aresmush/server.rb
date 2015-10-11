require 'eventmachine'

module AresMUSH
  class Server
    
    def start
      EventMachine.error_handler{ |e|
        Global.logger.error "Error raised during event loop: error=#{e} backtrace=#{e.backtrace[0,10]}"
      }

      EventMachine::run do
        host = Global.read_config("server", "hostname")
        port = Global.read_config("server", "port")
        EventMachine::add_periodic_timer(45) do
          Global.client_monitor.logged_in_clients.each { |c| c.ping }
          Cron.raise_event
        end
                
        EventMachine::start_server(host, port, Connection) do |connection|
          Global.client_monitor.connection_established(connection)
        end
        Global.logger.info "Server started on #{host}:#{port}."
        Global.dispatcher.queue_event GameStartedEvent.new
      end
    end   
  end
end
