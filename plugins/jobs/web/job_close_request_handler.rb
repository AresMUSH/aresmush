module AresMUSH
  module Jobs
    class JobCloseRequestHandler
      def handle(request)
        enactor = request.enactor
        job = Job[request.args[:id]]
        
        error = WebHelpers.check_login(request)
        return error if error
        
        if (!enactor.is_admin?)
          return { error: t('dispatcher.not_allowed') }
        end
        
        if (!job)
          return { error: t('webportal.not_found') }
        end
        
        Jobs.close_job(enactor, job)
        
        {
        }
      end
    end
  end
end