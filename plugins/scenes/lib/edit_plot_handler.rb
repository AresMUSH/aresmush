module AresMUSH
  module Scenes
    class EditPlotRequestHandler
      def handle(request)
        plot = Plot[request.args[:id]]
        enactor = request.enactor
        
        if (!plot)
          return { error: "Plot not found." }
        end
        
        if (!enactor.is_approved?)
          return { error: "You are not allowed to edit plots until you're approved." }
        end
        
        [ :title, :summary, :description ].each do |field|
          if (request.args[field].blank?)
            return { error: "#{field.to_s.titlecase} is required."}
          end
        end
        
        
        plot.update(summary: request.args[:summary])
        plot.update(title: request.args[:title])
        plot.update(description: request.args[:description])
        {}
      end
    end
  end
end