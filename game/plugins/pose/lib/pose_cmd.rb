module AresMUSH
  module Pose
    class PoseCmd
      include AresMUSH::Plugin

      def after_initialize
        @client_monitor = Global.client_monitor
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("emit") ||
        cmd.root_is?("pose") || 
        cmd.root_is?("say") || 
        cmd.root_is?("ooc")
      end
      
      def validate
        return t('dispatcher.must_be_logged_in') if !client.logged_in?
        return t('pose.invalid_pose_syntax') if !cmd.switch.nil?
        return nil
      end
      
      def handle
        room = client.room
        room.emit message
      end
      
      def log_command
        # Don't log poses
      end
      
      def message
        if (cmd.root_is?("emit"))
          return PoseFormatter.format(client.name, "\\#{cmd.args}")
        elsif (cmd.root_is?("pose"))
          return PoseFormatter.format(client.name, ":#{cmd.args}")
        elsif (cmd.root_is?("ooc"))
          msg = PoseFormatter.format(client.name, "#{cmd.args}")
          return "%xc<OOC>%xn #{msg}"
        end
        return PoseFormatter.format(client.name, "\"#{cmd.args}")
      end
    end
  end
end
