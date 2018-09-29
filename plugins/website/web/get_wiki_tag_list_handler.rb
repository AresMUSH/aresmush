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

        tags.uniq.select { |t| t != "" }
      end
    end
  end
end
