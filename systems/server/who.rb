module AresMUSH
  module ServerEvents
    class Who
      def initialize(config_reader, client_monitor)
        @config_reader = config_reader
        @client_monitor = client_monitor
        @client_monitor.register(self)
      end

      def handle(client, cmd)
        if cmd =~ /who/i
          client.emit t('players_connected', :count => @client_monitor.clients.count)
        end      
      end
    end
  end
end
