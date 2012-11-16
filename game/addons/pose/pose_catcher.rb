module AresMUSH
  module Pase
    class PoseCatcher
      include AresMUSH::Addon

      def after_initialize
        @client_monitor = container.client_monitor
      end
      
      def want_command?(cmd)
        cmd.raw.start_with?("\"") ||
        cmd.raw.start_with?("\\") ||
        cmd.raw.start_with?(":") ||
        cmd.raw.start_with?(";")
      end
      
      def on_command(client, cmd)
        @client_monitor.tell_all client.parse_pose(cmd.raw)
      end
    end
  end
end
