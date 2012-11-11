module AresMUSH
  module Pose
    class Pose
      include AresMUSH::Addon

      def after_initialize
        @client_monitor = container.client_monitor
      end
      
      def commands
        {
          "pose" => " (?<msg>.+)", 
          "\:"   => "(?<msg>.+)"
        }
      end
      
      def on_player_command(client, cmd)
        @client_monitor.tell_all "Client #{client.id} #{cmd[:msg]}"
      end
    end
  end
end
