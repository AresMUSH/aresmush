module AresMUSH
  module Scenes
    class PoseCmd
      include CommandHandler
      
      def check_room
        return t('scenes.no_talking_quiet_room') if enactor_room == Game.master.quiet_room
        return nil
      end
      
      def handle
        if (cmd.args && cmd.args.downcase == "order")
          client.emit_failure t('scenes.pose_order_mistake')
          return
        end
        is_emit = false
        is_ooc = false
                
        if (cmd.args.blank?)
          client.emit_failure t('scenes.no_pose_given')
          return
        end
        
        if (cmd.root_is?("emit"))
          is_emit = true
          message = cmd.args
        elsif (cmd.root_is?("pose"))
          message = ":#{cmd.args}"
        elsif (cmd.root_is?("ooc"))
          message = cmd.args
          is_ooc = true
        else
          message = "\"#{cmd.args}"
        end
        
        if (is_emit)
          formatted_message = message
        else
          formatted_message = PoseFormatter.format(enactor_name, message)
        end

        emit_to_room = Scenes.send_to_ooc_chat_if_needed(enactor, client, message, is_emit)
        if emit_to_room
          Scenes.emit_pose(enactor, formatted_message, is_emit, cmd.root_is?("ooc"))
        end  
      end
      

      def log_command
        # Don't log poses
      end
    end
  end
end
