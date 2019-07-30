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
          description: request.args[:description],
          summary: request.args[:summary],
          content_warning: request.args[:content_warning]
        )

        Global.logger.debug "Plot #{plot.id} created by #{enactor.name}."

        storyteller_names = request.args[:storytellers] || []
        plot.storytellers.replace []

        storyteller_names.each do |storyteller|
          storyteller = Character.find_one_by_name(storyteller.strip)
          if (storyteller)
            if (!plot.storytellers.include?(storyteller))
              Scenes.add_storyteller(plot, storyteller)
            end
          end
        end

        { id: plot.id }
      end
    end
  end
end
