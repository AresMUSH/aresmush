module AresMUSH
  module Jobs
    class JobChangeStatusRequestHandler
      def handle(request)
        enactor = request.enactor
        job = Job[request.args[:id]]
	status = request.args[:status].upcase

        error = Website.check_login(request)
        return error if error

        if (!job)
          return { error: t('webportal.not_found') }
        end

	if (!Jobs.status_vals.include?(status))
          return { error: t('jobs.invalid_status') }
        end

        if (job.author != enactor)
          if (!enactor.is_admin?)
            return { error: t('dispatcher.not_allowed') }
          end
        end

        job.update(status: status)

	notification = t('jobs.job_status_changed', :number => job.id, :title => job.title, :name => enactor.name, :status => status.titlecase)
        Jobs.notify(job, notification, enactor)
        {
        }
      end
    end
  end
end
