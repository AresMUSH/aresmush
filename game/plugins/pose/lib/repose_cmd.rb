module AresMUSH
  module Pose
    class ReposeCmd
      include CommandHandler
      
      def handle
        if (!enactor.room.repose_on?)
          client.emit_failure t('pose.repose_disabled')
          return
        end
        
        repose = enactor.room.repose_info
        poses = repose.poses || []
        client.emit BorderedDisplay.list poses.map { |p| "#{p}%R"}, t('pose.repose_list')
      end
    end
  end
end
