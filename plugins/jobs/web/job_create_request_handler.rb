module AresMUSH
  module Jobs
    class JobCreateRequestHandler
      def handle(request)
        enactor = request.enactor
        category = (request.args[:category] || "").upcase
        title = request.args[:title]
        description = request.args[:description]
        submitter_name = request.args[:submitter]
        
        error = Website.check_login(request)
        return error if error
        
        
        if (submitter_name)
          submitter = Character.named(submitter_name)
          if (!submitter)
            return { error: t('webportal.not_found') }
          end
        else
          submitter = enactor
        end

        result = Jobs.create_job(category, title, description, submitter)
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