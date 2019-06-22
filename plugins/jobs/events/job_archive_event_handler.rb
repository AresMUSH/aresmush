module AresMUSH
  module Jobs    
    class JobArchiveCronHandler
      def on_event(event)
        config = Global.read_config("jobs", "archive_cron")
        return if !Cron.is_cron_match?(config, event.time)
        
        Global.logger.debug "Archiving jobs."
        
        archive_job_days = Global.read_config('jobs', 'archive_job_days') || 10
        old_jobs = Job.find(status: 'DONE').each do |j|
          time_since_close = Time.now - (j.date_closed || Time.new(2018))
          if (time_since_close > (86400 * archive_job_days)) 
            j.update(status: 'ARCHIVED')
          end
        end
      end
    end    
  end
end