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
        cmd_str = (cmd.raw || "").strip
        
        if (cmd_str.start_with?("\\\\"))
          message = cmd_str.after("\\\\")
          is_emit = true
        elsif (cmd_str.start_with?("\\"))
            message = cmd_str.after("\\")
            is_emit = true
        elsif (cmd_str.start_with?("'"))
          message = PoseFormatter.format(enactor_name, cmd_str.after("'"))
          is_ooc = true
        elsif (cmd_str.start_with?(">"))
          message =  PoseFormatter.format(enactor_name, cmd_str.after(">"))
          is_ooc = true
        else
          message = PoseFormatter.format(enactor_name, cmd_str)
        end
        

        emit_to_room = Scenes.send_to_ooc_chat_if_needed(enactor, client, PoseFormatter.format(enactor.ooc_name, cmd_str), is_emit)
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
