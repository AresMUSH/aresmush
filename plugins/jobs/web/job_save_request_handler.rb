module AresMUSH
  module Jobs
    class JobSaveRequestHandler
      def handle(request)
        enactor = request.enactor
        category_name = (request.args[:category] || "").upcase
        status = (request.args[:status] || "").upcase
        participant_ids = request.args[:participants]
        title = request.args[:title]
        description = request.args[:description]
        submitter_name = request.args[:submitter]
        assignee_name = request.args[:assigned_to]
        tags = request.args[:tags]

        error = Website.check_login(request)
        return error if error
        
        if (title.blank?)
          return { error: t('webportal.missing_required_fields') }
        end
        
        request.log_request
        
        job = Job[request.args[:id]]
        if (!job)
          return { error: t('webportal.not_found') }
        end
        
        job_admin = Jobs.can_access_jobs?(enactor)
        if (!job_admin)
          return { error: t('dispatcher.not_allowed')}
        end
        
        error = Jobs.check_job_access(enactor, job)
        if (error)
          return { error: error }
        end
        
        Global.logger.debug "Job #{job.id} details updated by #{enactor.name}."
        
        submitter = Character.named(submitter_name)
        if (!submitter)
          return { error: t('webportal.not_found') }
        end
        
        if (assignee_name)
          assignee = Character.named(assignee_name)
          if (!assignee)
            return { error: t('webportal.not_found') }
          end
        else
          assignee = nil
        end
        
        category =  JobCategory.named(category_name)
        if (!category)
          return { error: t('webportal.not_found') }
        end
        
        participants = []
        if (participant_ids)
          participant_ids.each do |p|
            participant = Character[p]
            if (!participant)
              return { error: t('dispatcher.not_found') }
            end
            participants << participant
          end
        end
        
        job.update(
          title: title,
          author: submitter,
          assigned_to: assignee,
          status: status,
          job_category: category,
          description: Website.format_input_for_mush(description)
        )
        job.participants.replace participants
        Website.update_tags(job, tags)
        
        Jobs.notify(job, t('jobs.updated_job', :name => enactor.name, :title => job.title, :number => job.id), enactor)
       
                
        {
          id: job.id
        }
      end
    end
  end
end