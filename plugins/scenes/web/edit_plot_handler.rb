module AresMUSH
  module Scenes
    class EditPlotRequestHandler
      def handle(request)
        plot = Plot[request.args[:id]]
        enactor = request.enactor
        
        if (!plot)
          return { error: t('webportal.not_found') }
        end
        
        error = WebHelpers.check_login(request)
        return error if error
        
        if (!enactor.is_approved?)
          return { error: t('dispatcher.not_allowed') }
        end
        
        [ :title, :summary, :description ].each do |field|
          if (request.args[field].blank?)
            return { error: t('webportal.missing_required_fields') }
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