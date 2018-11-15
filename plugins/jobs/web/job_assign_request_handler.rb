module AresMUSH
  module Jobs
    class JobAssignRequestHandler
      def handle(request)
        enactor = request.enactor
        job = Job[request.args[:id]]
        assignee = Character[request.args[:assignee_id]]

        error = Website.check_login(request)
        return error if error

        if (!job)
          return { error: t('webportal.not_found') }
        end

        if (!assignee)
          return { error: t('webportal.not_found') }
        end

        error = Jobs.check_job_access(enactor, job)
        if (error)
          return { error: error }
        end
        
        error = Jobs.check_job_access(assignee, job)
        if (error)
          return { error: t('jobs.cannot_handle_jobs') }
        end
        
        Jobs.assign(job, assignee, enactor)

        {
        }
      end
    end
  end
end