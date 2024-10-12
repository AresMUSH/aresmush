module AresMUSH
  module Jobs    
    class JobCronEventHandler
      def on_event(event)
        archive_config = Global.read_config("jobs", "archive_cron")
        if Cron.is_cron_match?(archive_config, event.time)
          archive_jobs
        end
        
        schedules = Global.read_config("jobs", "scheduled_jobs") || []
        schedules.each do |sched|
          cron = sched["cron"]
          if (cron && Cron.is_cron_match?(cron, event.time))
            run_scheduled_job(sched)
          end
        end
        
      end
      
      def archive_jobs()
        
        Global.logger.debug "Archiving jobs."
        
        archive_job_days = Global.read_config('jobs', 'archive_job_days') || 10
        archived_status = (Global.read_config('jobs', 'archived_status') || "ARCHIVED").upcase
        
        (Global.read_config('jobs', 'closed_statuses') || []).each do |status|
          next if status == archived_status
          
          old_jobs = Job.find(status: status).each do |j|
            time_since_close = Time.now - (j.date_closed || Time.new(2018))
            if (time_since_close > (86400 * archive_job_days)) 
              j.update(status: archived_status)
            end
          end
        end
      end
      
      def run_scheduled_job(sched)
        Global.logger.debug "Running scheduled job."
        Jobs.create_job(sched["category"], 
           sched["title"], 
           sched["message"], 
           Game.master.system_character)        
      end
      
    end    
  end
end