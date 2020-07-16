module AresMUSH
  module Jobs
    class JobDeleteReplyRequestHandler
      def handle(request)
        enactor = request.enactor
        job = Job[request.args[:id]]
      	reply = JobReply[request.args[:reply_id]]
        
        error = Website.check_login(request)
        return error if error

        if (!job || !reply)
          return { error: t('webportal.not_found') }
        end

        if !Jobs.can_access_jobs?(enactor)
          return { error: t('dispatcher.not_allowed') }
        end
        
        error = Jobs.check_job_access(enactor, job)
        if (error)
          return { error: error }
        end
        
        reply.delete
        
        {
        }
      end
    end
  end
end