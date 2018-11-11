module AresMUSH
  module Scenes
    class PoseCatcherCmd
      include CommandHandler
           
      def handle
        message = PoseFormatter.format(enactor_name, cmd.raw)
        is_emit = cmd.raw.start_with?("\\")
        is_ooc = cmd.raw.start_with?("'") || cmd.raw.start_with?(">")

        Places.reset_place_if_moved(enactor)
        Scenes.emit_pose(enactor, message, is_emit, is_ooc)
      end

      def log_command
        # Don't log poses
      end 
    end
  end
end
