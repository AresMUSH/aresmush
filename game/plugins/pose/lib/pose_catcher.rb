module AresMUSH
  module Pase
    class PoseCatcher
      include AresMUSH::Plugin

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
        @client_monitor.emit_all Formatters.parse_pose(cmd.enactor_name, cmd.raw)
      end
    end
  end
end
