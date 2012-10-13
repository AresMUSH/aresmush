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
        EventMachine::start_server(host, port, Connection) do |connection|
          @client_monitor.connection_established(connection)
        end
        puts _t('server_start', :host => host, :port => port)
      end
    end   
  end
end