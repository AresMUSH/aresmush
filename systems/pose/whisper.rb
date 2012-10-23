module AresMUSH
  module Commands
    class Whisper
      def initialize(config_reader, client_monitor)
        @config_reader = config_reader
        @client_monitor = client_monitor
        @client_monitor.register(self)
      end
      
      def handles
        ["whisper  (?<target>[^=]+)=(?<msg>.+)"]
      end
      
      def handle(client, cmd)
        @client_monitor.tell_all "You whisper #{cmd[:msg]} to #{cmd[:target]}"
      end
    end
  end
end
