module AresMUSH
  module Scenes
    class PoseCatcherCmd
      include CommandHandler
           
      def check_quiet_room
        return t('scenes.no_talking_quiet_room') if enactor_room == Game.master.quiet_room
        return nil
      end
      
      def handle
        is_emit = false
        is_ooc = false
        
        if (cmd.raw.start_with?("\\\\"))
          message = cmd.raw.after("\\\\")
          is_emit = true
        elsif (cmd.raw.start_with?("\\"))
            message = cmd.raw.after("\\")
            is_emit = true
        elsif (cmd.raw.start_with?("'"))
          message = PoseFormatter.format(enactor_name, cmd.raw.after("'"))
          is_ooc = true
        elsif (cmd.raw.start_with?(">"))
          message =  PoseFormatter.format(enactor_name, cmd.raw.after(">"))
          is_ooc = true
        else
          message = PoseFormatter.format(enactor_name, cmd.raw)
        end
        

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
