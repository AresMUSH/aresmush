module AresMUSH
  module Pase
    class Emit
      include AresMUSH::Addon

      def after_initialize
        @client_monitor = container.client_monitor
      end
      
      def want_command?(client, cmd)
        logged_in?(client) && cmd.cmd_root_is?("emit")
      end
      
      def on_command(client, cmd)
        args = crack(client, cmd)
        @client_monitor.tell_all client.player.parse_pose("\\#{args[:msg]}")
      end
    end
  end
end
