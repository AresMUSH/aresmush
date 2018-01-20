module AresMUSH
  module Scenes
    class CreatePlotRequestHandler
      def handle(request)
        enactor = request.enactor
        
        error = WebHelpers.check_login(request)
        return error if error
        
        if (!enactor.is_approved?)
          return { error: "You are not allowed to create scenes until you're approved." }
        end
        
        [ :title, :summary, :description ].each do |field|
          if (request.args[field].blank?)
            return { error: "#{field.to_s.titlecase} is required."}
          end
        end
        
        plot = Plot.create(
          title: request.args[:title],
          description: request.args[:description],
          summary: request.args[:summary]
        )
                
        { id: plot.id }
      end
    end
  end
end