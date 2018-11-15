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
        
        # Authors can close their own jobs.
        error = Jobs.check_job_access(enactor, job, true)
        if (error)
          return { error: error }
        end
        
        Jobs.close_job(enactor, job)
        
        {
        }
      end
    end
  end
end