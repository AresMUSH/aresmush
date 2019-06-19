module AresMUSH
  module Scenes
    class GetScenesRequestHandler
      def handle(request)
                
        filter = request.args[:filter] || "Recent"
        page = (request.args[:page] || "1").to_i
        char_name_or_id = request.args[:char_id]
        
        if (char_name_or_id)
          char = Character.find_one_by_name(char_name_or_id)
          if (!char)
            return { error: t('webportal.not_found') }
          end
          scenes = char.scenes_starring.sort_by { |s| s.date_shared || s.created_at }.reverse
        elsif (filter == 'Recent')
          scenes = Scenes.recent_scenes
        elsif (filter == 'Popular')
          scenes = Scene.shared_scenes.select { |s| s.likes > 0 }.sort_by { |s| s.likes }.reverse
        elsif (filter == 'All')
          scenes = Scene.shared_scenes.sort_by { |s| s.date_shared || s.created_at }.reverse
        else # scene type filter
          scenes = Scene.shared_scenes.select { |s| s.scene_type == filter }.sort_by { |s| s.date_shared || s.created_at }.reverse
        end
        
        scenes_per_page = 30
        paginator = Paginator.paginate(scenes, page, scenes_per_page)
        
        if (paginator.out_of_bounds?)
          return { scenes: [], pages: [1] }
        end
        
        {
           scenes: paginator.page_items.map { |s| {
                  id: s.id,
                  title: s.title,
                  summary: s.summary,
                  location: s.location,
                  date_shared: s.date_shared,
                  icdate: s.icdate,
                  participants: s.participants.to_a.sort_by { |p| p.name }.map { |p| { name: p.name, id: p.id, icon: Website.icon_for_char(p) }},
                  scene_type: s.scene_type ? s.scene_type.titlecase : 'Unknown',
                  likes: s.likes
        
                }},
            pages: paginator.total_pages.times.to_a.map { |i| i+1 }
        }
      end
    end
  end
end