module AresMUSH
  module Scenes
    class CreatePlotRequestHandler
      def handle(request)
        enactor = request.enactor
        
        error = Website.check_login(request)
        return error if error
        
        if (!enactor.is_approved?)
          return { error: t('dispatcher.not_allowed') }
        end
        
        [ :title, :summary ].each do |field|
          if (request.args[field].blank?)
            return { error: t('webportal.missing_required_fields') }
          end
        end
        
        storyteller_names = request.args[:storytellers] || []
        
        plot = Plot.create(
          title: request.args[:title],
          description: request.args[:description],
          summary: request.args[:summary],
          content_warning: request.args[:content_warning]
        )

        storyteller_names.each do |storyteller|
          storyteller = Character.find_one_by_name(storyteller.strip)
          if (storyteller)
            if (!plot.storytellers.include?(storyteller))
              plot.storytellers.add storyteller
            end
          end
        end
                      
        Global.logger.info "Plot #{plot.id} created by #{enactor.name}."
  
        { id: plot.id }
      end
    end
  end
end