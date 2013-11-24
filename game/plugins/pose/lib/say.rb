module AresMUSH
  module Pose
    class Say
      include AresMUSH::Plugin

      def after_initialize
        @client_monitor = Global.client_monitor
      end
      
      def want_command?(cmd)
        cmd.root_is?("say")
      end
      
      def on_command(client, cmd)
        pose = Formatter.parse_pose(client.name, "\"#{cmd.args}")
        @client_monitor.emit_all pose
      end
    end
  end
end
