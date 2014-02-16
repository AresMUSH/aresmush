module AresMUSH
  module Pose
    class PoseCmd
      include AresMUSH::Plugin

      def after_initialize
        @client_monitor = Global.client_monitor
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("pose")
      end
      
      def validate
        return t('dispatcher.must_be_logged_in') if !client.logged_in?
        return t('pose.invalid_pose_syntax') if !cmd.switch.nil?
        return nil
      end
      
      def handle
        room = client.room
        room.emit PoseFormatter.format(client.name, ":#{cmd.args}")
      end

      def log_command
        # Don't log poses
      end      
    end
  end
end
