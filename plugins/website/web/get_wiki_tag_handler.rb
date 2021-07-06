module AresMUSH
  module Website
    class GetWikiTagRequestHandler
      def handle(request)
        tag = request.args[:id] || ''
        tag = tag.titlecase
        
        data = []
        
        groups = ContentTag.find(name: tag.downcase)
          .group_by { |t| Website.title_for_tag_group(t) }
        
        groups.each do |name, tags|
          data << {
            name: name,
            items: tags.map { |t| {
              id: t.content_id,
              route: Website.route_for_tag(t),
              title: Website.title_for_tag_item(t)
            }
            }}
        end
        
        {
          name: tag,
          groups: data
        }
      end
    end
  end
end