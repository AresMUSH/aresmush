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
          message = cmd_str.after("'")
          is_ooc = true
        elsif (cmd_str.start_with?(">"))
          message =  cmd_str.after(">")
          is_ooc = true
        else 
          message = cmd_str
        end
                
        if (message.blank?)
          client.emit_failure t('scenes.no_pose_given')
          return
        end
        
        if is_emit
          formatted_message = message
        else
          formatted_message = PoseFormatter.format(enactor_name, message)
        end
                
        emit_to_room = Scenes.send_to_ooc_chat_if_needed(enactor, client, message, is_emit)
        if (emit_to_room)
          Scenes.emit_pose(enactor, formatted_message, is_emit, is_ooc)
        end
      end

      def log_command
        # Don't log poses
      end 
    end
  end
end
