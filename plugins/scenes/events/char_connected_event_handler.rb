module AresMUSH
  module Scenes
    class CharConnectedEventHandler
      def on_event(event)
        char = Character[event.char_id]
        if (char.pose_nudge_muted)
          char.update(pose_nudge_muted: false)
        end
      end
    end
  end
end