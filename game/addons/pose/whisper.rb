module AresMUSH
  module Pose
    class Whisper
      include AresMUSH::Addon

      def after_initialize
        @client_monitor = container.client_monitor
      end
      
      def commands
        {
          "whisper" => " (?<msg>.+)"
        }
      end
      
      def on_player_command(client, cmd)
        @client_monitor.tell_all "whisper #{cmd[:msg]}"
      end
    end
  end
end
