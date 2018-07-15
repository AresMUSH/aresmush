module AresMUSH
  module Scenes
    class GetSceneLocationsHandler
      def handle(request)

        scene = Scene[request.args[:id]]
        enactor = request.enactor
      
        if (!scene)
          return { error: t('webportal.not_found') }
        end
      
        error = WebHelpers.check_login(request, true)
        return error if error

        if (!Scenes.can_read_scene?(enactor, scene))
          return { error: t('scenes.scene_is_private') }
        end
      
        if (scene.completed)
          return { error: t('scenes.scene_already_completed') }
        end
      
        area = nil
        if (scene.room && scene.room.area)
          area = scene.room.area
        end
        
        Room.all.select { |r| r.room_type == "IC" }.sort_by { |r| [ r.area == area, r.name ] }.map { |r|
          r.name_and_area
        }
        
      end
    end
  end
end