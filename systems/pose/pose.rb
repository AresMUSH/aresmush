module AresMUSH
  module Commands
    class Pose
      def initialize(config_reader, client_monitor)
        @config_reader = config_reader
        @client_monitor = client_monitor
        @client_monitor.register(self)
      end
      
      def handles
        ["pose (?<msg>.+)", "\:(?<msg>.+)"]
      end
      
      def handle(client, cmd)
        msg = cmd[:msg]
        @client_monitor.tell_all "Client #{client.id} #{msg}"
      end
    end
  end
end
