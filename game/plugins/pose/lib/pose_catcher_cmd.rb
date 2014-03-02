module AresMUSH
  module Pose
    class PoseCatcher
      include AresMUSH::Plugin

      # Validators
      must_be_logged_in
      no_switches
      
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
    end
  end
end
