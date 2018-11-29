module AresMUSH
  module Jobs
    class JobChangeDataRequestHandler
      def handle(request)
        enactor = request.enactor
        job = Job[request.args[:id]]
      	type = (request.args[:type] || "").downcase
        data = (request.args[:data] || "").upcase
        
        error = Website.check_login(request)
        return error if error

        if (!job)
          return { error: t('webportal.not_found') }
        end

        error = Jobs.check_job_access(enactor, job)
        if (error)
          return { error: error }
        end

        case type
        when "status"
          if (!Jobs.status_vals.include?(data))
            return { error: t('jobs.invalid_status', :statuses => Jobs.status_vals.join(", ")) }
          end

          Jobs.change_job_status(enactor, job, data)
        when "category"
          if (!Jobs.categories.include?(data))
            return { error: t('jobs.invalid_category', :categories => Jobs.categories.join(', ')) }
          end

          Jobs.change_job_category(enactor, job, data)
        else
          raise "Invalid job change type: #{type}."
        end
        
        {
        }
      end
    end
  end
end