module AresMUSH
  module Website
    class GetWikiTagRequestHandler
      def handle(request)
        tag = request.args[:id] || ''
        tag = tag.titlecase
        
        tags = ContentTag.find(name: tag.downcase)
        
        pages = tags.select { |t| t.content_type == 'wiki' }.map { |t| WikiPage[t.content_id] }.map { |p| {
          id: p.id,
          heading: p.heading
        }}
           
        chars = tags.select { |t| t.content_type == 'char' }.map { |t| Character[t.content_id] }.map { |c| {
          id: c.id,
          name: c.name
        }}

        scenes = tags.select { |t| t.content_type == 'scene' }.map { |t| Scene[t.content_id] }.map { |s| {
          id: s.id,
          title: s.date_title
        }}
           
        events = tags.select { |t| t.content_type == 'event' }.map { |t| Event[t.content_id] }.map { |e| {
          id: e.id,
          title: e.title
        }}
        
        plots = tags.select { |t| t.content_type == 'plot' }.map { |t| Plot[t.content_id] }.map { |p| {
          id: p.id,
          title: p.title
        }}
         
       {
         pages: pages,
         chars: chars,
         scenes: scenes,
         events: events,
         plots: plots
       }
      end
    end
  end
end