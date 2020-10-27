module AresMUSH
  module Scenes
    class GetSceneRequestHandler
      def handle(request)
        scene = Scene[request.args[:id]]
        edit_mode = request.args[:edit_mode]
        enactor = request.enactor

        error = Website.check_login(request, true)
        return error if error
        
        if (!scene)
          return { error: t('webportal.not_found') }
        end
        
        if (edit_mode)
          can_edit = scene.shared ? Scenes.can_edit_scene?(enactor, scene) : Scenes.can_read_scene?(enactor, scene)
          if (!can_edit)
            return { error: t('dispatcher.not_allowed') }
          end
        else          
          if (!scene.shared)
            return { unshared: true }
          end
          if (enactor)
            scene.mark_read(enactor)
            Login.mark_notices_read(enactor, :scene, scene.id)
          end
        end
        
        if (edit_mode)
          log = scene.shared ? scene.scene_log.log : nil
          summary = Website.format_input_for_html(scene.summary)
        else
          log = Website.format_markdown_for_html(scene.scene_log.log)
          summary = Website.format_markdown_for_html(scene.summary)
        end
        
        participants = scene.participants.to_a
            .sort_by {|p| p.name }
            .map { |p| { name: p.name, id: p.id, icon: Website.icon_for_char(p), is_ooc: p.is_admin? || p.is_playerbit?  }}
            
        {
          id: scene.id,
          title: scene.title,
          location: scene.location,
          completed: scene.completed,
          shared: scene.shared,
          date_created: OOCTime.local_short_timestr(enactor, scene.created_at),
          summary: summary,
          content_warning: scene.content_warning,
          tags: scene.tags,
          icdate: scene.icdate,
          participants: participants,
          limit: scene.limit,
          privacy: scene.completed ? "Open" : (scene.private_scene ? "Private" : "Open"),
          scene_type: scene.scene_type ? scene.scene_type.titlecase : 'unknown',
          scene_pacing: scene.scene_pacing,
          log: log,
          plots: scene.related_plots.map { |plot| { title: plot.title, id: plot.id } },
          related_scenes: scene.related_scenes.sort_by { |r| r.date_title }.map { |r| { title: r.date_title, id: r.id }},
          can_edit: enactor && Scenes.can_edit_scene?(enactor, scene),
          can_delete: Scenes.can_delete_scene?(enactor, scene),
          has_liked: enactor && scene.has_liked?(enactor),
          likes: scene.likes
        }
      end
    end
  end
end