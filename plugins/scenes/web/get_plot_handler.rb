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
        
        scenes = plot.sorted_scenes.select { |s| s.shared }
            .sort_by { |s| s.icdate || s.created_at }
            .reverse
            .map { |s|  Scenes.build_scene_summary_web_data(s) }
            
        storytellers = plot.storytellers.to_a
            .sort_by {|storyteller| storyteller.name }
            .map { |storyteller| { name: storyteller.name, id: storyteller.id, icon: Website.icon_for_char(storyteller), is_ooc: storyteller.is_admin? || storyteller.is_playerbit?  }}
                        
        {
          id: plot.id,
          title: plot.title,
          summary: summary,
          description: description,
          start_date: plot.start_date,
          end_date: plot.end_date,
          completed: plot.completed,
          content_warning: plot.content_warning,
          scenes: {
            scenes: scenes,
            pages: [ 1 ]
          },
          storytellers: storytellers
        }
      end
    end
  end
end