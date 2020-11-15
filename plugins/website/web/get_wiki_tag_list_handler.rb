module AresMUSH
  module Website
    class GetWikiTagListRequestHandler
      def handle(request)
        tags = []
        WikiPage.all.each do |p|
          tags = tags.concat p.tags
        end
        Character.all.each do |c|
          tags = tags.concat c.profile_tags
        end
        Scene.shared_scenes.each do |s|
          tags = tags.concat s.tags
        end
        Event.all.each do |e|
          tags = tags.concat e.tags
        end
        
      
        tags.uniq.sort
      end
    end
  end
end