module AresMUSH
  module Pose
    class ReposeCmd
      include CommandHandler
      include CommandRequiresLogin
      
      def handle
        room = client.char.room
        if (!Pose.repose_on(room))
          client.emit_failure t('pose.repose_disabled')
          return
        end
        
        client.emit BorderedDisplay.list room.poses.map { |p| "#{p}%R"}, t('pose.repose_list')
      end
    end
  end
end
