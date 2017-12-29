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
        Scene.all.each do |s|
          tags = tags.concat s.tags
        end
      
        tags.uniq
      end
    end
  end
end