module AresMUSH
  module Scenes
    class PlotRequestHandler
      def handle(request)
        edit_mode = request.args[:edit_mode]
        plot = Plot[request.args[:id]]
        enactor = request.enactor
        
        if (!plot)
          return { error: t('webportal.not_found') }
        end
        
        error = Website.check_login(request, true)
        return error if error
        
        if (edit_mode)
          description = plot.description
          summary = plot.summary
        else
          description = plot.description.blank? ? nil : Website.format_markdown_for_html(plot.description)
          summary = Website.format_markdown_for_html(plot.summary)
        end
        
        scenes = plot.scenes.select { |s| s.shared }
            .sort_by { |s| s.date_shared || s.created_at }.reverse.map { |s|  {
            id: s.id,
            title: s.title,
            summary: s.summary,
            location: s.location,
            icdate: s.icdate,
            participants: s.participants.to_a.sort_by { |p| p.name }.map { |p| { name: p.name, id: p.id, icon: Website.icon_for_char(p) }},
            scene_type: s.scene_type ? s.scene_type.titlecase : 'Unknown',
            }}
            
        storyteller = plot.storyteller || Game.master.system_character
        
        {
          id: plot.id,
          title: plot.title,
          summary: summary,
          description: description,
          start_date: plot.start_date,
          end_date: plot.end_date,
          scenes: scenes,
          storyteller: { name: storyteller.name, id: storyteller.id, icon: Website.icon_for_char(storyteller) }
        }
      end
    end
  end
end