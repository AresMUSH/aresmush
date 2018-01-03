module AresMUSH
  module Scenes
    class GetSceneRequestHandler
      def handle(request)
        scene = Scene[request.args[:id]]
        edit_mode = request.args[:edit_mode]
        enactor = request.enactor
        
        if (!scene)
          return { error: "Scene not found." }
        end
        
        if (!scene.shared)
          return { error: "That scene has not been shared." }
        end
        
        if (edit_mode)
          log = scene.scene_log.log
        else
          log = WebHelpers.format_markdown_for_html(scene.scene_log.log)
        end
        
        participants = scene.participants.to_a
            .sort_by {|p| p.name }
            .map { |p| { name: p.name, id: p.id, icon: WebHelpers.icon_for_char(p) }}
            
        {
          id: scene.id,
          title: scene.title,
          location: scene.location,
          summary: scene.summary,
          tags: scene.tags,
          icdate: scene.icdate,
          participants: participants,
          scene_type: scene.scene_type ? scene.scene_type.titlecase : 'unknown',
          log: log,
          plot: scene.plot ? { title: scene.plot.title, id: scene.plot.id } : nil,
          related_scenes: scene.related_scenes.map { |r| { title: r.title, id: r.id }},
          can_edit: enactor && Scenes.can_edit_scene?(enactor, scene),
          can_delete: enactor && enactor.is_admin?,
          has_liked: enactor && scene.has_liked?(enactor),
          likes: scene.likes
        }
      end
    end
  end
end