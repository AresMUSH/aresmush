module AresMUSH
  module Pose_History
    class PoseHistoryCmd
      include Plugin
      include PluginRequiresLogin
      
      def want_command?(client, cmd)
        cmd.root_is?("history")
      end
      
      def handle
        client.emit @pose_history[client.room.id].map { |k,v| "%R#{V}"}
          
      end
  end
end
