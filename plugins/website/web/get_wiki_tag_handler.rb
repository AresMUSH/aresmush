module AresMUSH
  module Website
    class GetWikiTagRequestHandler
      def handle(request)
        tag = request.args[:id] || ''
        tag = tag.titlecase
        pages = WikiPage.all.select { |p| p.tags.include?(tag.downcase) }
           .sort_by { |p| p.heading }
           .map { |p| {
             id: p.name,
             heading: p.heading
           }}
           
        chars = Character.all.select { |c| c.profile_tags.include?(tag.downcase) }
           .sort_by { |c| c.name }
           .map { |c| {
             id: c.id,
             name: c.name
           }}
        scenes = Scene.all.select { |s| s.tags.include?(tag.downcase) }
           .sort_by { |s| s.date_title }
           .map { |s| {
             id: s.id,
             title: s.date_title
           }}
           {
             pages: pages,
             chars: chars,
             scenes: scenes
           }
      end
    end
  end
end