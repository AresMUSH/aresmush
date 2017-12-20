module AresMUSH
  module Scenes
    class PoseEventHandler
      def on_event(event)
        enactor = event.enactor
        room = enactor.room
        scene = room.scene
        if (scene)
          Scenes.add_to_scene(scene, event.pose, enactor, event.is_setpose)
        elsif (room.scene_nag && room.room_type != "OOC")
          Rooms.emit_ooc_to_room(room, t('scenes.scene_nag'))
          room.update(scene_nag: false)
        end
      end
    end
  end
end