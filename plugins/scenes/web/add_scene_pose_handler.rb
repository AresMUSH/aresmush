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
        is_emit = pose_type == 'emit'
        
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
        
        if (!scene.room)
          raise "Trying to pose to a scene that doesn't have a room."
        end
        
        Global.logger.debug "Scene #{scene.id} pose added by #{enactor.name}."
        
        pose = Website.format_input_for_mush(pose)
        
        command = ((pose.split(" ").first) || "").downcase
        if (command == "ooc")
          is_ooc = true
          pose = pose.after(" ")
          pose = PoseFormatter.format(enactor.name, pose)
        elsif (command == "scene/set" || command == "emit/set")
          is_setpose = true
          pose = pose.after(" ")
        elsif (command == "emit")
          pose = pose.after(" ")
        else
          markers = PoseFormatter.pose_markers
          markers.delete "\""
          markers.delete "'"
          if (pose.start_with?(*markers) || is_ooc)
            pose = PoseFormatter.format(enactor.name, pose)
          end
        end
        
        Scenes.emit_pose(enactor, pose, is_emit, is_ooc, nil, is_setpose, scene.room)
        
        {
        }
      end
    end
  end
end