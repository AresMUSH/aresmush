module AresMUSH
  module Pose
    class Emit
      include AresMUSH::Plugin

      def after_initialize
        @client_monitor = Global.client_monitor
      end
      
      def want_command?(cmd)
        cmd.logged_in? && cmd.root_is?("emit")
      end
      
      def on_command(client, cmd)
        room = client.location
        room.emit PoseFormatter.format(client.name, "\\#{cmd.args}")
      end
    end
  end
end
