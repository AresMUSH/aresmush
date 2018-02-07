module AresMUSH
  module Scenes
    class LiveScenesRequestHandler
      def handle(request)
        enactor = request.enactor
        
        error = WebHelpers.check_login(request, true)
        return error if error
        
        
        Scene.all.select { |s| !s.completed }.sort_by { |s| s.updated_at }.reverse.map { |s| {
                  id: s.id,
                  title: s.title,
                  summary: s.summary,
                  location: s.location,
                  icdate: s.icdate,
                  can_view: enactor && Scenes.can_access_scene?(enactor, s),
                  is_private: s.private_scene,
                  participants: s.participants.to_a.sort_by { |p| p.name }.map { |p| { name: p.name, id: p.id, icon: WebHelpers.icon_for_char(p) }},
                  scene_type: s.scene_type ? s.scene_type.titlecase : 'Unknown',
                  likes: s.likes,
                  is_unread: enactor && Scenes.can_access_scene?(enactor, s) && s.participants.include?(enactor) && s.is_unread?(enactor),
                  updated: OOCTime.local_long_timestr(enactor, s.updated_at)
        
                }}
      end
    end
  end
end