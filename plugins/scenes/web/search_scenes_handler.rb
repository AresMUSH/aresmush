module AresMUSH
  module Scenes
    class SearchScenesRequestHandler
      def handle(request)

        searchLog = (request.args[:searchLog] || "").strip
        searchParticipant = (request.args[:searchParticipant] || "").strip
        searchTitle = (request.args[:searchTitle] || "").strip
        searchTag = (request.args[:searchTag] || "").strip
        searchDate = (request.args[:searchDate] || "").strip
        
        scenes = Scene.shared_scenes
        
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
          scenes = scenes.select { |s| s.participants.map { |p| p.name.upcase }.include?(searchParticipant.upcase) }
        end
        
        if (!searchTag.blank?)
          scenes = scenes.select { |s| s.tags.include?(searchTag.downcase) }
        end
                
        scenes.sort_by { |s| s.date_shared || s.created_at }.reverse.map { |s| {
                          id: s.id,
                          title: s.title,
                          summary: s.summary,
                          location: s.location,
                          icdate: s.icdate,
                          participants: s.participants.to_a.sort_by { |p| p.name }.map { |p| { name: p.name, id: p.id, icon: Website.icon_for_char(p) }},
                          scene_type: s.scene_type ? s.scene_type.titlecase : 'Unknown',
                          likes: s.likes
        
                        }}
      end
    end
  end
end