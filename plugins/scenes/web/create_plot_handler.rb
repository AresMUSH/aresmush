module AresMUSH
  module Scenes
    class CreatePlotRequestHandler
      def handle(request)
        enactor = request.enactor
        storyteller = Character[request.args[:storyteller_id]]
        
        error = Website.check_login(request)
        return error if error
        
        if (!storyteller)
          return { error: t('webportal.not_found') }
        end
        
        if (!enactor.is_approved?)
          return { error: t('dispatcher.not_allowed') }
        end
        
        [ :title, :summary ].each do |field|
          if (request.args[field].blank?)
            return { error: t('webportal.missing_required_fields') }
          end
        end
        
        plot = Plot.create(
          title: request.args[:title],
          storyteller: storyteller,
          description: request.args[:description],
          summary: request.args[:summary]
        )
              
        Global.logger.debug "Plot #{plot.id} created by #{enactor.name}."
  
        { id: plot.id }
      end
    end
  end
end