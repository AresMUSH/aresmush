module AresMUSH
  module Pose
    class CharConnectedEventHandler
      def on_event(event)
        if (event.char.pose_nudge_muted)
          event.char.update(pose_nudge_muted: false)
        end
      end
    end
  end
end