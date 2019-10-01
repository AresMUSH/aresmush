module AresMUSH
  module Scenes
    class PoseEventHandler
      def on_event(event)
        enactor = Character[event.enactor_id]
        room = Room[event.room_id]
        scene = room.scene
        if (scene && !scene.completed)
          Scenes.add_to_scene(scene, event.pose, enactor, event.is_setpose, event.is_ooc, event.place_name)
        elsif (room.scene_nag && room.room_type != "OOC")
          room.emit_ooc t('scenes.scene_nag')
          room.update(scene_nag: false)
        end
        
        if (!event.is_ooc)
          Scenes.handle_word_count_achievements(enactor, event.pose)
        end
      end
    end
  end
end