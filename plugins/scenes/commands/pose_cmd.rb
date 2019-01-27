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
        Places.reset_place_if_moved(enactor)
        emit_to_room = Scenes.send_to_ooc_chat_if_needed(enactor, client, message(enactor.ooc_name))
        if emit_to_room
          Scenes.emit_pose(enactor, message(enactor_name), cmd.root_is?("emit"), cmd.root_is?("ooc"))
        end
        
      end
      
      def message(name)
        if (cmd.root_is?("emit"))
          return PoseFormatter.format(name, "\\#{cmd.args}")
        elsif (cmd.root_is?("pose"))
          return PoseFormatter.format(name, ":#{cmd.args}")
        elsif (cmd.root_is?("ooc"))
          return PoseFormatter.format(name, "#{cmd.args}")
        end
        return PoseFormatter.format(name, "\"#{cmd.args}")
      end

      def log_command
        # Don't log poses
      end
    end
  end
end
