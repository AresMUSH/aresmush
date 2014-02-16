module AresMUSH
  module Pose
    class OOCSay
      include AresMUSH::Plugin

      def after_initialize
        @client_monitor = Global.client_monitor
      end
      
      def want_command?(client, cmd)
        client.logged_in? && cmd.root_is?("ooc")
      end
      
      def handle
        room = client.room
        pose = PoseFormatter.format(client.name, "#{cmd.args}")
        room.emit "%xc<OOC>%xn #{pose}"
      end

      def log_command
        # Don't log poses
      end      
    end
  end
end
