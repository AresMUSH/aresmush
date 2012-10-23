module AresMUSH
  module Commands
    class Who
      def initialize(config_reader, client_monitor)
        @config_reader = config_reader
        @client_monitor = client_monitor
        @client_monitor.register(self)
      end

      def handles
        ["who", "where"]
      end
      
      def handle(client, cmd)
        client.emit t('players_connected', :count => @client_monitor.clients.count)
      end
    end
  end
end
