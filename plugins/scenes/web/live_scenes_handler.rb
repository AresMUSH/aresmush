module AresMUSH
  module Scenes
    class LiveScenesRequestHandler
      def handle(request)
        enactor = request.enactor
        
        error = Website.check_login(request, true)
        return error if error
        
        
        Scene.all.select { |s| !s.completed }.sort { |s1, s2| sort_scene(s1, s2) }.reverse.map { |s| {
                  id: s.id,
                  title: s.title,
                  summary: s.summary,
                  location: Scenes.can_read_scene?(enactor, s) ? s.location : t('scenes.private'),
                  icdate: s.icdate,
                  can_view: enactor && Scenes.can_read_scene?(enactor, s),
                  is_private: s.private_scene,
                  participants: Scenes.participants_and_room_chars(s)
                      .select { |p| !p.who_hidden }
                      .sort_by { |p| p.name }
                      .map { |p| { 
                         name: p.name, 
                         id: p.id, 
                         icon: Website.icon_for_char(p), 
                         online: Login.is_online?(p),
                         last_posed: s.last_posed == p }},
                  scene_type: s.scene_type ? s.scene_type.titlecase : 'Unknown',
                  likes: s.likes,
                  is_unread: enactor && Scenes.can_read_scene?(enactor, s) && s.participants.include?(enactor) && s.is_unread?(enactor),
                  updated: OOCTime.local_long_timestr(enactor, s.last_activity),
                  watching: Scenes.is_watching?(s, enactor),
                  participating: Scenes.is_participant?(s, enactor),
                  last_posed: s.last_posed ? s.last_posed.name : nil
                }}
      end
      
      def sort_scene(s1, s2)
        if (!s1.private_scene && s2.private_scene)
          return 1
        end
        
        if (s1.private_scene && !s2.private_scene)
          return -1
        end
        
        if (s1.updated_at < s2.updated_at)
          return 1
        end
        
        if (s2.updated_at < s1.updated_at)
          return -1
        end
        
        return 0
        
      end
    end
  end
end