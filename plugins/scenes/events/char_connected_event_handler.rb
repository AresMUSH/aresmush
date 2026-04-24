module AresMUSH
  module Scenes
    class CharConnectedEventHandler
      def on_event(event)
        client = event.client
        char = Character[event.char_id]
        
        # Pose nudge is a client-only thing, so don't mess with its setting for a web connection
        return if !client
        
        if (char.pose_nudge_muted)
          char.update(pose_nudge_muted: false)
        end
      end
    end
  end
end