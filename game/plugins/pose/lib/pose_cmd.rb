module AresMUSH
  module Pose
    class PoseCmd
      include Plugin
      include PluginRequiresLogin

      def want_command?(client, cmd)
        (cmd.root_is?("ooc") && !cmd.args.nil?) ||
        cmd.root_is?("emit") ||
        cmd.root_is?("pose") || 
        cmd.root_is?("say")
      end
      
      def handle
        Pose.emit_pose(client, message, cmd.root_is?("emit"))
	if (!cmd.root_is?("ooc"))        
	  log_pose
	end
      end
      
      def log_pose
        Pose_Order.update_order(client.room.id, client.name, Time.now.to_i)
      end
       
      def message
        if (cmd.root_is?("emit"))
          return PoseFormatter.format(client.name, "\\#{cmd.args}")
        elsif (cmd.root_is?("pose"))
          return PoseFormatter.format(client.name, ":#{cmd.args}")
        elsif (cmd.root_is?("ooc"))
          msg = PoseFormatter.format(client.name, "#{cmd.args}")
          color = Global.config['pose']['ooc_color']
          return "#{color}<OOC>%xn #{msg}"
        end
        return PoseFormatter.format(client.name, "\"#{cmd.args}")
      end
    end
  end
end
