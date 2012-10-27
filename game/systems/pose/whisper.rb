module AresMUSH
  module Commands
    class Whisper
      def initialize(container)
        @client_monitor = container.client_monitor
      end
      
      def commands
        ["whisper (?<msg>.+)", "\\\\(?<msg>.+)"]
      end
      
      def handle(client, cmd)
        @client_monitor.tell_all "whisper #{cmd[:msg]}"
      end
    end
  end
end
