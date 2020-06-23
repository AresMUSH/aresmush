module AresMUSH  

  module Migrations
    class MigrationBeta80Update
      def require_restart
        true
      end
      
      def migrate
               
        Global.logger.debug "Migrating read jobs."
        Character.all.each do |c|
          if ((c.read_jobs || []).any?)
            tracker = c.get_or_create_read_tracker
            tracker.update(read_jobs: c.read_jobs.uniq)
            c.update(read_jobs: [])
          end
        end
     
      end
    end    
  end
end