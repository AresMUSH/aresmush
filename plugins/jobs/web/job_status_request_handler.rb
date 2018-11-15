module AresMUSH
  module Jobs
    class JobChangeStatusRequestHandler
      def handle(request)
        enactor = request.enactor
        job = Job[request.args[:id]]
      	status = (request.args[:status] || "").upcase

        error = Website.check_login(request)
        return error if error

        if (!job)
          return { error: t('webportal.not_found') }
        end

        error = Jobs.check_job_access(enactor, job)
        if (error)
          return { error: error }
        end

        if (!Jobs.status_vals.include?(status))
          return { error: t('jobs.invalid_status', :statuses => Jobs.status_vals.join(", ")) }
        end

        Jobs.change_job_status(enactor, job, status)

        {
        }
      end
    end
  end
end