module AresMUSH
  module Scenes
    class PoseEventHandler
      def on_event(event)
        enactor = event.enactor
        scene = enactor.room.scene
        if (scene && !event.is_ooc)
          Scenes.add_pose(scene, event.pose, enactor, event.is_setpose)
        end
      end
    end
  end
end