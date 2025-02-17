require 'eventmachine'

module AresMUSH
  # @engineinternal true
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
      bind_address = Global.read_config("server", "bind_address")
      if (!bind_address.blank?)
        host = bind_address
      end

      EventMachine::run do
        port = Global.read_config("server", "port")
        EventMachine::add_periodic_timer(45) do
          AresMUSH.with_error_handling(nil, "Cron timer") do
            Cron.raise_event
          end
        end
        
        EventMachine::add_periodic_timer(20) do
          AresMUSH.with_error_handling(nil, "Web Client Ping") do
            Global.client_monitor.ping_web_clients
          end
        end
           
        begin     
          EventMachine::start_server(host, port, Connection) do |connection|
            AresMUSH.with_error_handling(nil, "Connection established") do
              Global.client_monitor.connection_established(connection)
            end
          end
        rescue Exception => ex
          Global.logger.fatal "Couldn't start the game: error=#{ex} backtrace=#{ex.backtrace[0,10]}"
          EventMachine.stop_event_loop
          exit 1
        end
        
        engine_api_port = Global.read_config("server", "engine_api_port")
        web = EngineApiLoader.new
        web.run(port: engine_api_port)
                
        Global.logger.info "Server started on #{host}:#{port}."
        Global.dispatcher.queue_event GameStartedEvent.new
      end
    end
  end
end
