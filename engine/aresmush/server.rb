require 'eventmachine'
require 'em-websocket'

module AresMUSH
  class Server
    def start
      EventMachine.error_handler{ |e|
        begin
          Global.logger.error "Error raised during event loop: error=#{e} backtrace=#{e.backtrace[0,10]}"
        rescue
          puts "Error handling error: #{e}"
        end
      }

      host = Global.read_config("server", "hostname")

      EventMachine::run do
        port = Global.read_config("server", "port")
        EventMachine::add_periodic_timer(45) do
          AresMUSH.with_error_handling(nil, "Cron timer") do
            Cron.raise_event
          end
        end
                
        EventMachine::start_server(host, port, Connection) do |connection|
          AresMUSH.with_error_handling(nil, "Connection established") do
            Global.client_monitor.connection_established(connection)
          end
        end
        
        websocket_port = Global.read_config("server", "websocket_port")
          EventMachine::WebSocket.start(:host => host, :port => websocket_port) do |websocket|
            AresMUSH.with_error_handling(nil, "Web connection established") do
              WebConnection.new(websocket) do |connection|
                Global.client_monitor.connection_established(connection)
              end
            end
          end
        Global.logger.info "Websocket started on #{host}:#{websocket_port}."
        Global.logger.info "Server started on #{host}:#{port}."
        Global.dispatcher.queue_event GameStartedEvent.new
      end
    end
  end
end
