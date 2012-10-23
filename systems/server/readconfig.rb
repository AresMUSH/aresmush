module AresMUSH
  module Commands
    class ReadConfig
      def initialize(config_reader, client_monitor)
        @config_reader = config_reader
        @client_monitor = client_monitor
        @client_monitor.register(self)
      end

      def self.name
        "ReadConfig"
      end
      
      def handle(client, cmd)
        if cmd =~ /^readconfig/
          @config_reader.read
          client.emit "%% You reload the config files."
        end      
      end
    end
  end
end
