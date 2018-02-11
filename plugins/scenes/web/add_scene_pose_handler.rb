module AresMUSH
  module Scenes
    class AddScenePoseRequestHandler
      def handle(request)
        scene = Scene[request.args[:id]]
        enactor = request.enactor
        pose = request.args[:pose]
        pose_type = request.args[:pose_type]
        is_setpose = pose_type == 'setpose'
        is_ooc = pose_type == 'ooc'
        
        if (!scene)
          return { error: t('webportal.not_found') }
        end
        
        error = WebHelpers.check_login(request, true)
        return error if error

        if (!Scenes.can_access_scene?(enactor, scene))
          return { error: t('scenes.access_not_allowed') }
        end
        
        if (scene.completed)
          return { error: t('scenes.scene_already_completed') }
        end
        
        pose = WebHelpers.format_input_for_mush(pose)
        
        if (is_ooc)
          pose = PoseFormatter.format(enactor.name, pose)
          color = Global.read_config("scenes", "ooc_color")
          formatted_pose = "#{color}<OOC>%xn #{pose}"
        elsif (is_setpose)
          line = "%R%xh%xc%% #{'-'.repeat(75)}%xn%R"
          formatted_pose = "#{line}%R#{pose}%R#{line}"
        else
          formatted_pose = pose
        end
        
        Scenes.add_to_scene(scene, pose, enactor, is_setpose, is_ooc)
        if (scene.room)
          scene.room.characters.each do |char|
            client = Login.find_client(char)
            next if !client
            client.emit Scenes.custom_format(formatted_pose, char, enactor, true, false, nil)
          end
        end
        
        {
        }
      end
    end
  end
end