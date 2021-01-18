module AresMUSH
  module Scenes
    class DeletePlotRequestHandler
      def handle(request)
        plot = Plot[request.args[:id]]
        enactor = request.enactor
        
        if (!plot)
          return { error: t('webportal.not_found') }
        end
        
        request.log_request
        
        error = Website.check_login(request)
        return error if error
        
        if (!enactor.is_admin?)
          return { error: t('dispatcher.not_allowed') }
        end
        
        Website.add_to_recent_changes('plot', t('scenes.plot_deleted', :title => plot.title), {}, enactor.name)
        
        plot.delete
        {
        }
      end
    end
  end
end