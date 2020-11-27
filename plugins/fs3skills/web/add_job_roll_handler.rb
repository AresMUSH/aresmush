module AresMUSH
  module FS3Skills
    class AddJobRollRequestHandler
      def handle(request)
        job = Job[request.args[:id]]
        enactor = request.enactor
        
        if (!job)
          return { error: t('webportal.not_found') }
        end
        
        error = Website.check_login(request)
        return error if error

        if (!Jobs.can_access_job?(enactor, job, true))
          return { error: t('jobs.cant_view_job') }
        end
        
        if (!job.is_open?)
          return { error: t('jobs.job_already_closed') }
        end
        
        result = FS3Skills.determine_web_roll_result(request, enactor)
        
        return result if result[:error]

        Jobs.comment(job, Game.master.system_character, result[:message], false)
        
        {
        }
      end
    end
  end
end