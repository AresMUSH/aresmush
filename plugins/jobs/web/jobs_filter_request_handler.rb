module AresMUSH
  module Jobs
    class JobsFilterRequestHandler
      def handle(request)
        enactor = request.enactor
        filter = (request.args[:filter] || "").upcase
        
        error = Website.check_login(request)
        return error if error
        
        error = Jobs.check_filter_type(filter)
        if (error)
            return { error: error }
        end
        
        enactor.update(jobs_filter: filter)
                
        JobsRequestHandler.new.handle(request)
      end
    end
  end
end