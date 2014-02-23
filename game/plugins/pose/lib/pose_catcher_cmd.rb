module AresMUSH
  module Pose
    class PoseCatcher
      include AresMUSH::Plugin

      # Validators
      must_be_logged_in
      
      def after_initialize
        @client_monitor = Global.client_monitor
      end
      
      def want_command?(client, cmd)
        cmd.raw.start_with?("\"") ||
        cmd.raw.start_with?("\\") ||
        cmd.raw.start_with?(":") ||
        cmd.raw.start_with?(";")
      end
      
      def handle
        room = client.room
        room.emit PoseFormatter.format(client.name, cmd.raw)
      end

      def log_command
        # Don't log poses
      end 

      # It will get mixed up and think that "who/bar" has a switch      
      def validate_check_for_allowed_switches
        nil
      end     
    end
  end
end
