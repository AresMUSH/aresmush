module AresMUSH
  module Scenes
    class SearchScenesRequestHandler
      def handle(request)

        searchLog = (request.args[:searchLog] || "").strip
        searchParticipant = (request.args[:searchParticipant] || "").strip
        searchTitle = (request.args[:searchTitle] || "").strip
        searchTag = (request.args[:searchTag] || "").strip
        searchType = (request.args[:searchType] || "All").strip
        searchDate = (request.args[:searchDate] || "").strip
        searchLocation = (request.args[:searchLocation] || "").strip
        page = (request.args[:page] || "1").to_i
        
        scenes = Scene.shared_scenes
        
        case searchType
        when "Recent"
          scenes = scenes[0..(scenes_per_page - 1)]
        when "Popular"
          scenes = scenes.select { |s| s.likes > 0 }
                         .sort_by { |s| s.likes }.reverse[0..(scenes_per_page - 1)]
        when "All"
          # Already set.
        else
          # Scene type filter
          scenes = scenes.select { |s| s.scene_type == searchType }
        end
        
        if (!searchTitle.blank?)
          scenes = scenes.select { |s| s.title =~ /\b#{searchTitle}\b/i }
        end
                
        if (!searchLog.blank?)
          scenes = scenes.select { |s| "#{s.summary} #{s.scene_log.log}" =~ /\b#{searchLog}\b/i }
        end
        
        if (!searchDate.blank?)
          scenes = scenes.select { |s| s.icdate.start_with?(searchDate) }
        end
        
        if (!searchParticipant.blank?)
          names = searchParticipant.upcase.split(" ")
          scenes = scenes.select { |s| (names & s.participants.map { |p| p.name.upcase }).count == names.count }
        end
        
        if (!searchTag.blank?)
          scenes = scenes.select { |s| s.tags.include?(searchTag.downcase) }
        end
        
        if (!searchLocation.blank?)
          scenes = scenes.select { |s| s.location =~ /\b#{searchLocation}\b/i }
        end
        
        scenes = scenes.sort_by { |s| s.date_shared || s.created_at }.reverse
        scenes_per_page = 30
        
        paginator = Paginator.paginate(scenes, page, scenes_per_page)
        
        if (paginator.out_of_bounds?)
          return { scenes: [], pages: nil }
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