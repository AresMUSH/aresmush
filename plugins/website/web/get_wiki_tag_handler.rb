module AresMUSH
  module Website
    class GetWikiTagRequestHandler
      def handle(request)
        tag = request.args[:id] || ''
        tag = tag.downcase
        
        enactor = request.enactor
        
        error = Website.check_login(request, true)
        return error if error
        
        data = []
        
        groups = ContentTag.find(name: tag.downcase)
          .group_by { |t| Website.title_for_tag_group(t) }
        
        groups.each do |name, tags|
          items = build_tag_items(tags, enactor)
          
          if (items.any?)
            data << {
              name: name,
              items: items
            }
          end
        end
        
        if (data.count == 0)
          return { error: t('webportal.no_tag_content_visible') }
        end
        
        {
          name: tag,
          groups: data
        }
      end
      
      def build_tag_items(tags, enactor)
        items = []
        tags.each do |t|
          model = Website.find_model_for_tag(t)
          if (Website.is_tag_item_visible?(model, enactor))
            items << {
              id: t.content_id,
              route: Website.route_for_tag(t),
              route_id: Website.route_id_for_tag(model),
              title: Website.title_for_tag_item(model),
              type: t.content_type
            }
          end
        end
        items
      end
    end
  end
end