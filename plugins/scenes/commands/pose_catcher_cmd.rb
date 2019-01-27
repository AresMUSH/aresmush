module AresMUSH
  module Scenes
    class PoseCatcherCmd
      include CommandHandler
           
      def check_quiet_room
        return t('scenes.no_talking_quiet_room') if enactor_room == Game.master.quiet_room
        return nil
      end
      
      def handle
        message = PoseFormatter.format(enactor_name, cmd.raw)
        is_emit = cmd.raw.start_with?("\\")
        is_ooc = cmd.raw.start_with?("'") || cmd.raw.start_with?(">")

        Places.reset_place_if_moved(enactor)

        emit_to_room = Scenes.send_to_ooc_chat_if_needed(enactor, client, PoseFormatter.format(enactor.ooc_name, cmd.raw))
        if (emit_to_room)
          Scenes.emit_pose(enactor, message, is_emit, is_ooc)
        end
      end

      def log_command
        # Don't log poses
      end 
    end
  end
end
