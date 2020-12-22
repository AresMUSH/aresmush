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
        
        plot.delete
        {
        }
      end
    end
  end
end