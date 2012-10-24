module AresMUSH
  module Commands
    class ReadConfig
      def initialize(container)
        @client_monitor = container.client_monitor
        @config_reader = container.config_reader
      end

      def commands
        ["readconfig"]
      end

      def handle(client, cmd)
        @config_reader.read
        client.emit "%% You reload the config files."
      end
    end
  end
end
