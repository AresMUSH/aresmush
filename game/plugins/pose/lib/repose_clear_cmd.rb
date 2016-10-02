module AresMUSH
  module Pose
    class ReposeClearCmd
      include CommandHandler
      include CommandRequiresLogin
      
      def check_repose_enabled
        return t('pose.repose_disabled') if !Pose.repose_enabled
      end
      
      def handle
        room = client.char.room        
        room.pose_order = {}
        room.poses = []
        room.save
        
        client.emit_success t('pose.repose_cleared')
      end
    end
  end
end
