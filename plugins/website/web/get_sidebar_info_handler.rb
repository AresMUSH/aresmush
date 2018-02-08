module AresMUSH
  module Website
    class GetSidebarInfoRequestHandler
      def handle(request)
        enactor = request.enactor
        
        error = WebHelpers.check_login(request, true)
        return error if error
        
        
        sixty_days_in_seconds = 86400 * 60
                
        recent_profiles = ProfileVersion.all.select { |p| Time.now - p.created_at < sixty_days_in_seconds }.uniq { |p| p.character }
        recent_wiki = WikiPageVersion.all.select { |w| Time.now - w.created_at < sixty_days_in_seconds}.uniq { |w| w.wiki_page }
        
        recent_changes = []
        recent_profiles.each do |p|
          recent_changes << {
            title: p.character.name,
            id: p.id,
            change_type: 'char',
            created: p.created_at,
            name: p.character.name
          }
        end
        recent_wiki.each do |w|
          recent_changes << {
            title: w.wiki_page.heading,
            id: w.id,
            change_type: 'wiki',
            created: w.created_at,
            name: w.wiki_page.name
          }
        end
          
        recent_changes = recent_changes.sort_by { |r| r[:created] }[0..10]
        
        {
          game: GetGameInfoRequestHandler.new.handle(request),
          upcoming_events: Events::UpcomingEventsRequestHandler.new.handle(request),
          recent_scenes: Scenes::RecentScenesRequestHandler.new.handle(request),
          happenings: Who::WhoRequestHandler.new.handle(request),
          unread_mail: enactor ? enactor.unread_mail.count : nil,
          recent_changes: WebHelpers.get_recent_changes(true, 10)
        }
      end
    end
  end
end