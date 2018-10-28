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
      bind_address = Global.read_config("server", "bind_address")
      if (!bind_address.blank?)
        host = bind_address
      end

      EventMachine::run do
        port = Global.read_config("server", "port")
        # EventMachine::add_periodic_timer(45) do
        #   AresMUSH.with_error_handling(nil, "Cron timer") do
        #     Cron.raise_event
        #   end
        # end

	EventMachine::start_server(host, port, Connection) do |connection|
          AresMUSH.with_error_handling(nil, "Connection established") do
            Global.client_monitor.connection_established(connection)
          end
        end

	engine_api_port = Global.read_config("server", "engine_api_port")
        web = EngineApiLoader.new
        web.run(port: engine_api_port)

	websocket_port = Global.read_config("server", "websocket_port")

	if (Global.read_config("server", "ssl"))
	  EventMachine::WebSocket.start(
	    :host => host,
 	    :port => websocket_port,
  	    :secure => true,
              :tls_options => {
                :private_key_file => "/home/ares/ssl-cert/privkey.pem",
      	        :cert_chain_file => "/home/ares/ssl-cert/fullchain.pem"
              }) do |websocket|
	    AresMUSH.with_error_handling(nil, "Web connection established") do
              WebConnection.new(websocket) do |connection|
                Global.client_monitor.connection_established(connection)
              end
            end
	   end
	else
	  EventMachine::WebSocket.start(:host => host, :port => websocket_port) do |websocket|
            AresMUSH.with_error_handling(nil, "Web connection established") do
              WebConnection.new(websocket) do |connection|
                Global.client_monitor.connection_established(connection)
              end
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
