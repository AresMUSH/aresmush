module AresMUSH
  module EventHandlers
    class Whisper
      def initialize(container)
        @client_monitor = container.client_monitor
      end
      
      def commands
        ["whisper (?<msg>.+)", "\\\\(?<msg>.+)"]
      end
      
      def on_player_command(client, cmd)
        @client_monitor.tell_all "whisper #{cmd[:msg]}"
      end
    end
  end
end
