module AresMUSH
  module Commands
    class Quit
      def initialize(config_reader, client_monitor)
        @config_reader = config_reader
        @client_monitor = client_monitor
        @client_monitor.register(self)
      end

      def self.name
        "Quit"
      end
      
      def handle(client, cmd)
        puts "Quit handling"
        if cmd =~ /quit/i
          client.disconnect
        end      
      end
    end
  end
end
