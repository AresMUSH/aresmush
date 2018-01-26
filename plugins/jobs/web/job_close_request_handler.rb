module AresMUSH
  module Jobs
    class JobCloseRequestHandler
      def handle(request)
        enactor = request.enactor
        job = Job[request.args[:id]]
        
        error = WebHelpers.check_login(request)
        return error if error
        
        if (!enactor.is_admin?)
          return { error: "You are not an admin." }
        end
        
        if (!job)
          return { error: "Invalid job." }
        end
        
        Jobs.close_job(enactor, job)
        
        {
        }
      end
    end
  end
end