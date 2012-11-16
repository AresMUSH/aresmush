module AresMUSH
  module Pase
    class PoseCatcher
      include AresMUSH::Addon

      def after_initialize
        @client_monitor = container.client_monitor
      end
      
      def commands
        { "\"" => "(?<msg>.+)", 
          "\\" => "(?<msg>.+)",
          ":" => "(?<msg>.+)",
          ";" => "(?<msg>.+)" }
      end
      
      def on_command(client, cmd)
        @client_monitor.tell_all client.player.parse_pose(cmd[:msg])
      end
    end
  end
end
