module AresMUSH
  module Login
    class Quit
      include AresMUSH::Addon

      def commands
        { "quit" => "" }
      end
      
      def on_player_command(client, cmd)
        client.disconnect
      end
    end
  end
end
