module AresMUSH
  module Jobs
    class JobCreateRequestHandler
      def handle(request)
        enactor = request.enactor
        category = (request.args[:category] || "").upcase
        title = request.args[:title]
        description = request.args[:description]
        
        error = Website.check_login(request)
        return error if error

        result = Jobs.create_job(category, title, description, enactor)
        if (result[:error])
          return {error: job[:error] }
        end
        job = result[:job]
        
        {
          id: job.id
        }
      end
    end
  end
end