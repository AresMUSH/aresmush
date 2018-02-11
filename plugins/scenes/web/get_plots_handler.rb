module AresMUSH
  module Scenes
    class PlotsRequestHandler
      def handle(request)
        Plot.all.to_a.reverse.map { |p| {
                  id: p.id,
                  title: p.title,
                  summary: p.summary,
                  start_date: p.start_date,
                  end_date: p.end_date
                }}
      end
    end
  end
end