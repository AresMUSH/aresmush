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
        puts t('server_start', :host => host, :port => port)
        puts l(Date.today, :format => :short)  
      end
    end   
  end
end