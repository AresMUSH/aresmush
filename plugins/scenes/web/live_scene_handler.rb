module AresMUSH
  module Scenes
    class LiveSceneRequestHandler
      def handle(request)
        scene = Scene[request.args[:id]]
        enactor = request.enactor
        
        if (!scene)
          return { error: t('webportal.not_found') }
        end
        
        error = Website.check_login(request, true)
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
            
          if (!Scenes.is_watching?(scene, enactor))
            scene.watchers.add enactor
          end

        end
        
        participants = Scenes.participants_and_room_chars(scene)
            .sort_by {|p| p.name }
            .map { |p| { 
              name: p.name, 
              id: p.id, 
              icon: Website.icon_for_char(p), 
              is_ooc: p.is_admin? || p.is_playerbit?,
              online: Login.is_online?(p)  }}
            
        {
          id: scene.id,
          title: scene.title,
          location: {
            name: scene.location,
            description: scene.room ? Website.format_markdown_for_html(scene.room.expanded_desc) : nil,
            scene_set: scene.room ? Website.format_markdown_for_html(scene.room.scene_set) : nil },
          completed: scene.completed,
          summary: scene.summary,
          tags: scene.tags,
          icdate: scene.icdate,
          is_private: scene.private_scene,
          participants: participants,
          scene_type: scene.scene_type ? scene.scene_type.titlecase : 'unknown',
          can_edit: enactor && Scenes.can_read_scene?(enactor, scene),
          is_muted: enactor && scene.muters.include?(enactor),
          poses: scene.poses_in_order.map { |p| { 
            char: { name: p.character.name, icon: Website.icon_for_char(p.character) }, 
            order: p.order, 
            id: p.id,
            timestamp: OOCTime.local_long_timestr(enactor, p.created_at),
            is_setpose: p.is_setpose,
            is_system_pose: p.is_system_pose?,
            is_ooc: p.is_ooc,
            raw_pose: p.pose,
            can_edit: !p.is_system_pose? && p.can_edit?(enactor),
            pose: Website.format_markdown_for_html(p.pose) }}
        }
      end
    end
  end
end