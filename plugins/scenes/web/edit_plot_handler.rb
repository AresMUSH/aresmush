module AresMUSH
  module Scenes
    class EditPlotRequestHandler
      def handle(request)
        plot = Plot[request.args[:id]]
        enactor = request.enactor
        
        if (!plot)
          return { error: t('webportal.not_found') }
        end
        
        error = Website.check_login(request)
        return error if error
        
        if (!enactor.is_approved?)
          return { error: t('dispatcher.not_allowed') }
        end
        
        Global.logger.info "Plot #{plot.id} edited by #{enactor.name}."
        
        [ :title, :summary ].each do |field|
          if (request.args[field].blank?)
            return { error: t('webportal.missing_required_fields') }
          end
        end
        
        storyteller_names = request.args[:storytellers] || []
        plot.storytellers.replace []
        
        storyteller_names.each do |storyteller|
          storyteller = Character.find_one_by_name(storyteller.strip)
          if (storyteller)
            if (!plot.storytellers.include?(storyteller))
              plot.storytellers.add storyteller
            end
          end
        end
        
        plot.update(summary: request.args[:summary])
        plot.update(content_warning: request.args[:content_warning])
        plot.update(title: request.args[:title])
        plot.update(description: request.args[:description])
        plot.update(completed: (request.args[:completed] || "").to_bool)
        
        Website.add_to_recent_changes('plot', t('scenes.plot_updated', :title => plot.title), { id: plot.id }, enactor.name)
        
        {}
      end
    end
  end
end