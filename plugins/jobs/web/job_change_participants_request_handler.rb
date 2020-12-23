module AresMUSH
  module Jobs
    class JobChangeParticipantsRequestHandler
      def handle(request)
        enactor = request.enactor
        job = Job[request.args[:id]]
        participant_ids = (request.args[:participants] || [])
        
        error = Website.check_login(request)
        return error if error

        request.log_request

        if (!job)
          return { error: t('webportal.not_found') }
        end

        error = Jobs.check_job_access(enactor, job, true)
        if (error)
          return { error: error }
        end

        participants = []
        participant_ids.each do |p|
          participant = Character[p]
          if (!participant)
            return { error: t('dispatcher.not_found') }
          end
          participants << participant
        end
        
        job.participants.replace participants
        Jobs.notify(job, t('jobs.participants_updated', :name => enactor.name, :num => job.id), enactor)
        
        
        {
        }
      end
    end
  end
end