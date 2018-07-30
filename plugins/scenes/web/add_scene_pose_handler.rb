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
        
        error = Website.check_login(request)
        return error if error

        if (!Scenes.can_access_scene?(enactor, scene))
          return { error: t('scenes.access_not_allowed') }
        end
        
        if (scene.completed)
          return { error: t('scenes.scene_already_completed') }
        end
        
        pose = Website.format_input_for_mush(pose)
        
        command = ((pose.split(" ").first) || "").downcase
        if (command == "ooc")
          is_ooc = true
          pose = pose.after(" ")
        elsif (command == "scene/set" || command == "emit/set")
          is_setpose = true
          pose = pose.after(" ")
        elsif (command == "emit")
          pose = pose.after(" ")
        end
        
        if (is_ooc)
          pose = PoseFormatter.format(enactor.name, pose)
          color = Global.read_config("scenes", "ooc_color")
          formatted_pose = "#{color}<OOC>%xn #{pose}"
        elsif (is_setpose)
          line = "%R%xh%xc%% #{'-'.repeat(75)}%xn%R"
          formatted_pose = "#{line}%R#{pose}%R#{line}"
          if (scene.room)
            scene.room.update(scene_set: pose)
          end
        else
          if (pose.start_with?(*PoseFormatter.pose_markers) && !pose.start_with?("\""))
            pose = PoseFormatter.format(enactor.name, pose)
          end
          orig_pose = pose
          formatted_pose = pose
        end
        
        Scenes.add_to_scene(scene, pose, enactor, is_setpose, is_ooc)
        scene.watchers.add enactor
        if (scene.room)
          scene.room.characters.each do |char|
            message = Scenes.custom_format(formatted_pose, char, enactor, true, false, nil)
            Global.client_monitor.emit_if_logged_in(char, message)
          end
        end
        
        {
        }
      end
    end
  end
end