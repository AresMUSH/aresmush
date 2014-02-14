module AresMUSH
  module Pose
    class Say
      include AresMUSH::Plugin

      def after_initialize
        @client_monitor = Global.client_monitor
      end
      
      def want_command?(cmd)
        cmd.logged_in? && cmd.root_is?("say")
      end
      
      def handle
        room = client.room
        room.emit PoseFormatter.format(client.name, "\"#{cmd.args}")
      end

      def log_command
        # Don't log poses
      end      
    end
  end
end
