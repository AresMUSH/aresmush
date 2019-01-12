module AresMUSH
  module Jobs
    class JobsFilterRequestHandler
      def handle(request)
        enactor = request.enactor
        filter = (request.args[:filter] || "").upcase
        
        error = Website.check_login(request)
        return error if error

        if (!Jobs.can_access_jobs?(enactor))
          return { error: t('dispatcher.not_allowed') }
        end
        
        error = Jobs.check_filter_type(filter)
        if (error)
          return { error: error }
        end
        
        enactor.update(jobs_filter: filter)
                
        {
        }
      end
    end
  end
end