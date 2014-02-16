module AresMUSH
  module Pose
    class EmitCmd
      include AresMUSH::Plugin

      def after_initialize
        @client_monitor = Global.client_monitor
      end
      
      def want_command?(client, cmd)
        client.logged_in? && cmd.root_is?("emit")
      end
      
      def validate
        return t('pose.invalid_pose_syntax') if !cmd.switch.nil?
      end
      
      def handle
        room = client.location
        room.emit PoseFormatter.format(client.name, "\\#{cmd.args}")
      end
      
      def log_command
        # Don't log poses
      end      
    end
  end
end
