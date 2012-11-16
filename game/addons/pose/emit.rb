module AresMUSH
  module Pase
    class Emit
      include AresMUSH::Addon

      def after_initialize
        @client_monitor = container.client_monitor
      end
      
      def want_command?(cmd)
        cmd.root_is?("emit")
      end
      
      def on_command(client, cmd)
        @client_monitor.tell_all client.parse_pose("\\#{cmd.args}")
      end
    end
  end
end
