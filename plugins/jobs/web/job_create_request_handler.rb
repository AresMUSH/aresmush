module AresMUSH
  module Jobs
    class JobCreateRequestHandler
      def handle(request)
        enactor = request.enactor
        category = (request.args[:category] || "").upcase
        participant_ids = request.args[:participants]
        title = request.args[:title]
        description = request.args[:description]
        submitter_name = request.args[:submitter]
        tags = request.args[:tags]
        
        error = Website.check_login(request)
        return error if error
        
        if (title.blank?)
          return { error: t('webportal.missing_required_fields') }
        end
        
        request.log_request
        
        job_admin = Jobs.can_access_jobs?(enactor)
        
        if (submitter_name)
          submitter = Character.named(submitter_name)
          if (!submitter)
            return { error: t('webportal.not_found') }
          end
          
          if (!job_admin && submitter.name != enactor.name)
            return { error: t('jobs.cannot_submit_from_someone_else') }
          end
        else
          submitter = enactor
        end

        notify_author = submitter_name && submitter.name != enactor.name
        
        result = Jobs.create_job(category, title, description, submitter, notify_author)
        if (result[:error])
          return {error: job[:error] }
        end
        job = result[:job]
        
        Website.update_tags(job, tags)
        
        if (participant_ids)
          participant_ids.each do |p|
            participant = Character[p]
            if (!participant)
              return { error: t('dispatcher.not_found') }
            end
            job.participants.add participant
          end
          Jobs.notify(job, t('jobs.participants_updated', :name => enactor.name, :num => job.id), enactor)
        end
        
        {
          id: job.id
        }
      end
    end
  end
end