module AresMUSH
  module Scenes
    class RecentScenesRequestHandler
      def handle(request)
        
      recent = Scene.shared_scenes
      .sort_by { |s| s.date_shared || s.created_at }.reverse[0..9] || []
      
      recent.map { |s| {
                id: s.id,
                title: s.title,
                summary: s.summary,
                location: s.location,
                icdate: s.icdate,
                participants: s.participants.to_a.sort_by { |p| p.name }.map { |p| { name: p.name, id: p.id, icon: Website.icon_for_char(p) }},
                scene_type: s.scene_type ? s.scene_type.titlecase : 'unknown',
      
              }}
      end
    end
  end
end