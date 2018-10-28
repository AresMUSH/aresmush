module AresMUSH
  module Scenes
    class PoseCmd
      include CommandHandler
      
      def handle
        if (cmd.args && cmd.args.downcase == "order")
          client.emit_failure t('scenes.pose_order_mistake')
          return
        end
        Places.reset_place_if_moved(enactor)
        Scenes.emit_pose(enactor, message, cmd.root_is?("emit"), cmd.root_is?("ooc"))
      end
      
      def log_command
        # Don't log poses
      end
      
      def message
        if (cmd.root_is?("emit"))
          return PoseFormatter.format(enactor_name, "\\#{cmd.args}")
        elsif (cmd.root_is?("pose"))
          return PoseFormatter.format(enactor_name, ":#{cmd.args}")
        elsif (cmd.root_is?("ooc"))
          return PoseFormatter.format(enactor_name, "#{cmd.args}")
        end
        return PoseFormatter.format(enactor_name, "\"#{cmd.args}")
      end
    end
  end
end
