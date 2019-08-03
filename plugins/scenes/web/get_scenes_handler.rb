module AresMUSH
  module Scenes
    class GetScenesRequestHandler
      def handle(request)
                
        filter = request.args[:filter] || "Recent"
        page = (request.args[:page] || "1").to_i
        char_name_or_id = request.args[:char_id]
        
        # Special limited filter for related scenes list
        if (filter == 'Related')
          return {
            scenes: Scene.shared_scenes.sort_by { |s| s.date_shared || s.created_at }
            .reverse.map { |s| {
              id: s.id,
              title: s.title
            }}
          }
        end
            
        if (char_name_or_id)
          char = Character.find_one_by_name(char_name_or_id)
          if (!char)
            return { error: t('webportal.not_found') }
          end
          
          if (filter == 'Recent')
            scenes = char.scenes_starring.sort_by { |s| s.date_shared || s.created_at }.reverse[0..20]
          else
            scenes = char.scenes_starring.sort_by { |s| s.icdate || s.created_at }.reverse
          end
        else
          if (filter == 'Recent')
            scenes = Scenes.recent_scenes
          else
            scenes = Scene.shared_scenes.sort_by { |s| s.date_shared || s.created_at }.reverse
          end
        end
        if (filter == 'Popular')
          scenes = scenes.select { |s| s.likes > 0 }.sort_by { |s| s.likes }.reverse
        elsif (filter == 'All' || filter == 'Recent')
          # No additional filtering.
        else # scene type filter
          scenes = scenes.select { |s| s.scene_type == filter }
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
                  summary: Website.format_markdown_for_html(s.summary),
                  content_warning: s.content_warning,
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