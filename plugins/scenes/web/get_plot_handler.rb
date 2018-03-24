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
        
        error = WebHelpers.check_login(request, true)
        return error if error
        
        if (edit_mode)
          description = plot.description
        else
          description = plot.description.blank? ? nil : WebHelpers.format_markdown_for_html(plot.description)
        end
        
        scenes = plot.scenes.select { |s| s.shared }
            .sort_by { |s| s.date_shared || s.created_at }.reverse.map { |s|  {
            id: s.id,
            title: s.title,
            summary: s.summary,
            location: s.location,
            icdate: s.icdate,
            participants: s.participants.to_a.sort_by { |p| p.name }.map { |p| { name: p.name, id: p.id, icon: WebHelpers.icon_for_char(p) }},
            scene_type: s.scene_type ? s.scene_type.titlecase : 'Unknown',
            }}
        {
          id: plot.id,
          title: plot.title,
          summary: plot.summary,
          description: description,
          start_date: plot.start_date,
          end_date: plot.end_date,
          scenes: scenes
        }
      end
    end
  end
end