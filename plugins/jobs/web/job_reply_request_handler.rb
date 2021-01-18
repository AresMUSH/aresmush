module AresMUSH
  module Jobs
    class JobReplyRequestHandler
      def handle(request)
        enactor = request.enactor
        job = Job[request.args[:id]]
        reply = request.args[:reply]
        admin_only = request.args[:admin_only].to_bool
        
        error = Website.check_login(request)
        return error if error

        request.log_request

        if (!job)
          return { error: t('webportal.not_found') }
        end
                
        # Authors can reply to their own job.
        error = Jobs.check_job_access(enactor, job, true)
        if (error)
          return { error: error }
        end
        
        reply = Website.format_input_for_mush(reply)
        Jobs.comment(job, enactor, reply, admin_only)
        
        {
        }
      end
    end
  end
end