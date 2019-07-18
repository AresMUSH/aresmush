module AresMUSH
  module Scenes
    class EditPlotRequestHandler
      def handle(request)
        plot = Plot[request.args[:id]]
        storyteller = Character[request.args[:storyteller_id]]
        enactor = request.enactor

        if (!plot || !storyteller)
          return { error: t('webportal.not_found') }
        end

        error = Website.check_login(request)
        return error if error

        if (!enactor.is_approved?)
          return { error: t('dispatcher.not_allowed') }
        end

        Global.logger.debug "Plot #{plot.id} edited by #{enactor.name}."

        [ :title, :summary ].each do |field|
          if (request.args[field].blank?)
            return { error: t('webportal.missing_required_fields') }
          end
        end

        storyteller_names = request.args[:storytellers] || []
        plot.storytellers.replace []

        Global.logger.debug "Names: #{storyteller_names}"

        storyteller_names.each do |storyteller|
          storyteller = Character.find_one_by_name(storyteller.strip)
          if (storyteller)
            if (!plot.storytellers.include?(storyteller))
              Scenes.add_storyteller(plot, storyteller)
              Global.logger.debug "Adding: #{storyteller.name} "
            end
          end
        end

        plot.update(storyteller: storyteller)
        plot.update(summary: request.args[:summary])
        plot.update(title: request.args[:title])
        plot.update(description: request.args[:description])
        {}
      end
    end
  end
end
