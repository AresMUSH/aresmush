module AresMUSH
  module Pose_History
    class PoseOrderCmd
      include Plugin
      include PluginRequiresLogin
      
      def want_command?(client, cmd)
        cmd.root_is?("order")
      end
      
      def handle
        client.emit @pose_history[client.room.id].map { |k,v| "%R#{k}"}
          
      end
  end
end
