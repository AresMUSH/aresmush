module AresMUSH
  module Jobs
    class JobsCatchupRequestHandler
      def handle(request)
        enactor = request.enactor
        
        error = Website.check_login(request)
        return error if error
        
        if (!Jobs.can_access_jobs?(enactor)) 
          return { error: t('dispatcher.not_allowed') }
        end
        
        enactor.unread_jobs.each do |job|
          Jobs.mark_read(job, enactor)
        end
        
        {}
        
      end
    end
  end
end