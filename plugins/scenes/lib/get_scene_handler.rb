module AresMUSH
  module Scenes
    class GetSceneRequestHandler
      def handle(request)
        scene = Scene[request.args[:id]]
        
        if (!scene)
          return { error: "Scene not found." }
        end
        
        if (!scene.shared)
          return { error: "That scene has not been shared." }
        end
        
        {
          type: 'scene',
          id: scene.id,
          title: scene.title,
          location: scene.location,
          summary: scene.summary,
          tags: scene.tags,
          icdate: scene.icdate,
          participants: scene.participants.to_a.sort_by {|p| p.name }.map { |p| { name: p.name, id: p.id, icon: WebHelpers.icon_for_char(p) }},
          scene_type: scene.scene_type ? scene.scene_type.downcase : 'unknown',
          log: WebHelpers.format_markdown_for_html(scene.scene_log.log),
          plot: scene.plot ? { title: scene.plot.title, id: scene.plot.id } : nil,
          related_scenes: scene.related_scenes.map { |r| { title: r.title, id: r.id }}
        }
      end
    end
  end
end