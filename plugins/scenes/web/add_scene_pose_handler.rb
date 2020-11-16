module AresMUSH
  module Scenes
    class AddScenePoseRequestHandler
      def handle(request)
        scene = Scene[request.args[:id]]
        enactor = request.enactor
        pose = (request.args[:pose] || "").chomp
        pose_char = request.args[:pose_char]
        pose_type = request.args[:pose_type]
        
        if (!scene)
          return { error: t('webportal.not_found') }
        end
        
        error = Website.check_login(request)
        return error if error

        if (!Scenes.can_read_scene?(enactor, scene))
          return { error: t('scenes.access_not_allowed') }
        end
        
        if (scene.completed)
          return { error: t('scenes.scene_already_completed') }
        end
        
        if (!scene.room)
          raise "Trying to pose to a scene that doesn't have a room."
        end

        char = pose_char ? Character[pose_char] : enactor

        if (!char)
          return { error: t('webportal.not_found') }
        end
        
        if !Scenes.can_pose_char?(enactor, char)
          return { error: t('dispatcher.not_allowed') }
        end
                  
        pose = Website.format_input_for_mush(pose)
        
        parse_results = Scenes.parse_web_pose(pose, char, pose_type)
        
        # Command
        if (parse_results[:command])
          parser = Scenes::BaseSceneCommands.new
          return parser.handle(enactor, char, scene, parse_results[:command], parse_results[:args])
          
        # Regular Pose or Emit
        else
          Scenes.emit_pose(char, parse_results[:pose], parse_results[:is_emit], 
             parse_results[:is_ooc], nil, parse_results[:is_setpose] || parse_results[:is_gmpose], scene.room)
        
          if (parse_results[:is_setpose] && scene.room)
            scene.room.update(scene_set: parse_results[:pose])
          end
        end
        
        {}
      end
    end
  end
end