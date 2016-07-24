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
            Global.client_monitor.logged_in_clients.each { |c| c.ping }
            Cron.raise_event
          end
        end
                
        EventMachine::start_server(host, port, Connection) do |connection|
          AresMUSH.with_error_handling(nil, "Connection established") do
            Global.client_monitor.connection_established(connection)
          end
        end

        AresMUSH.with_error_handling(nil, "Web connection established") do
          dispatch = Rack::Builder.app do
            map '/' do
              run WebApp.new
            end
          end

          # Start the web server. Note that you are free to run other tasks
          # within your EM instance.
          Rack::Server.start({
            app:    dispatch,
            server: 'thin',
            Host:   'localhost',
            Port:   '9292',
            signals: false,
          })
        end
        
        Global.logger.info "Server started on #{host}:#{port}."
        Global.dispatcher.queue_event GameStartedEvent.new
      end
    end
  end
end
