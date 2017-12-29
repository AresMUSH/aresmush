module AresMUSH
  module Scenes
    class GetScenesRequestHandler
      def handle(request)
        
        Scene.all.select { |s| s.shared }.sort_by { |s| s.date_shared || s.created_at }.reverse.map { |s| {
                  type: 'scene',
                  id: s.id,
                  title: s.title,
                  summary: s.summary,
                  location: s.location,
                  icdate: s.icdate,
                  participants: s.participants.to_a.sort_by { |p| p.name }.map { |p| { name: p.name, id: p.id, icon: WebHelpers.icon_for_char(p) }},
                  scene_type: s.scene_type ? s.scene_type.downcase : 'unknown',
        
                }}
      end
    end
  end
end