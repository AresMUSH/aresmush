module AresMUSH  

  module Migrations
    class MigrationBeta80Update
      def require_restart
        false
      end
      
      def migrate
               
        Global.logger.debug "Migrating read jobsn."
        Character.all.each do |c|
          if (!(c.read_jobs || []).empty?)
            tracker = c.get_or_create_job_tracker
            tracker.update(read_jobs: c.read_jobs)
          end
        end
     
      end
    end    
  end
end