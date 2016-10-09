module AresMUSH
  module Pose
    class ReposeCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandWithoutSwitches
      include CommandWithoutArgs
      
      def handle
        repose = enactor.room.repose_info
        if (!repose)
          client.emit_failure t('pose.repose_disabled')
          return
        end
        
        poses = repose.poses || []
        client.emit BorderedDisplay.list poses.map { |p| "#{p}%R"}, t('pose.repose_list')
      end
    end
  end
end
