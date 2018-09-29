module AresMUSH
  module Jobs
    class JobAssignRequestHandler
      def handle(request)
        enactor = request.enactor
        job = Job[request.args[:id]]
	assignee = Character[request.args[:staff_id]]

        error = Website.check_login(request)
        return error if error

        if (!job)
          return { error: t('webportal.not_found') }
        end

	if (!assignee)
	  return { error: t('webportal.not_found') }
	end

        if (job.author != enactor)
          if (!enactor.is_admin?)
            return { error: t('dispatcher.not_allowed') }
          end
        end
        
	job.update(assigned_to: assignee)
        
	notification = t('jobs.job_assigned', :number => job.id, :title => job.title, :assigner => enactor.name, :assignee => assignee.name)
        Jobs.notify(job, notification, enactor)
        {
        }
      end
    end
  end
end
