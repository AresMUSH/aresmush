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
        
        error = Website.check_login(request)
        return error if error
        
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

        result = Jobs.create_job(category, title, description, submitter)
        if (result[:error])
          return {error: job[:error] }
        end
        job = result[:job]
        
        if (participant_ids)
          participant_ids.each do |p|
            participant = Character[p]
            if (!participant)
              return { error: t('dispatcher.not_found') }
            end
            job.participants.add participant
          end
        end
        if (submitter_name && submitter.name != enactor.name)
          Jobs.notify_for_query(submitter, job)
        end
        
        {
          id: job.id
        }
      end
    end
  end
end