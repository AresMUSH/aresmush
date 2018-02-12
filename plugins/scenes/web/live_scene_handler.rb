module AresMUSH
  module Scenes
    class LiveSceneRequestHandler
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
        
        if (scene.shared)
          return { error: t('scenes.scene_already_shared') }
        end
        
        if (!scene.logging_enabled)
          return { error: t('scenes.cant_join_unlogged_scene')}
        end
        
        if (enactor)
          scene.mark_read(enactor)
        end
        
        participants = scene.participants.to_a
            .sort_by {|p| p.name }
            .map { |p| { name: p.name, id: p.id, icon: WebHelpers.icon_for_char(p) }}
            
        {
          id: scene.id,
          title: scene.title,
          location: scene.location,
          completed: scene.completed,
          summary: scene.summary,
          tags: scene.tags,
          icdate: scene.icdate,
          is_private: scene.private_scene,
          participants: participants,
          scene_type: scene.scene_type ? scene.scene_type.titlecase : 'unknown',
          can_edit: enactor && Scenes.can_access_scene?(enactor, scene),
          notify_watch: Global.read_config("scenes", "notify_of_web_watching"),
          poses: scene.poses_in_order.map { |p| { 
            char: { name: p.character.name, icon: WebHelpers.icon_for_char(p.character) }, 
            order: p.order, 
            is_setpose: p.is_setpose,
            is_system_pose: p.is_system_pose?,
            is_ooc: p.is_ooc,
            pose: WebHelpers.format_markdown_for_html(p.pose) }}
        }
      end
    end
  end
end