module AresMUSH
  module Jobs
    class JobCloseRequestHandler
      def handle(request)
        enactor = request.enactor
        job = Job[request.args[:id]]
        
        error = Website.check_login(request)
        return error if error
        
        if (!job)
          return { error: t('webportal.not_found') }
        end
        
        if (job.author != enactor)
          if (!enactor.is_admin?)
            return { error: t('dispatcher.not_allowed') }
          end
        end
        
        Jobs.close_job(enactor, job)
        
        {
        }
      end
    end
  end
end