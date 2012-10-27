module AresMUSH
  module EventHandlers
    class Say
      def initialize(container)
        @client_monitor = container.client_monitor
      end
      
      def commands
        ["say (?<msg>.+)", "\"(?<msg>.+)"]
      end
      
      def on_player_command(client, cmd)
        @client_monitor.tell_all "Client #{client.id} says \"#{cmd[:msg]}\""
      end
    end
  end
end
