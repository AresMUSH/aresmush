module AresMUSH
  module EventHandlers
    class Quit
      def initialize(container)
      end

      def commands
        ["quit"]
      end
      
      def on_player_command(client, cmd)
        client.disconnect
      end
    end
  end
end
