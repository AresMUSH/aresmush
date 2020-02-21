module AresMUSH
  module Scenes
    class PlotsRequestHandler
      def handle(request)
        Plot.all.to_a.sort_by { |p| [ p.end_date || Time.at(0), p.start_date ]}.reverse.map { |p| {
                  id: p.id,
                  title: p.title,
                  summary: Website.format_markdown_for_html(p.summary),
                  start_date: p.start_date,
                  end_date: p.end_date,
                  completed: p.completed,
                  content_warning: p.content_warning,
                  storytellers: get_storytellers(p)
                }}
      end

      def get_storytellers(plot)
        storytellers = plot.storytellers.to_a
            .sort_by {|storyteller| storyteller.name }
            .map { |storyteller| { name: storyteller.name, id: storyteller.id, icon: Website.icon_for_char(storyteller), is_ooc: storyteller.is_admin? || storyteller.is_playerbit?  }}
      end

      def get_storytellers(plot)
        storytellers = plot.storytellers.to_a
            .sort_by {|storyteller| storyteller.name }
            .map { |storyteller| { name: storyteller.name, id: storyteller.id, icon: Website.icon_for_char(storyteller), is_ooc: storyteller.is_admin? || storyteller.is_playerbit?  }}
      end

    end
  end
end
