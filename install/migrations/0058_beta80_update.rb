module AresMUSH  

  module Migrations
    class MigrationBeta80Update
      def require_restart
        false
      end
      
      def migrate
               
        Global.logger.debug "Migrating read jobs."
        Character.all.each do |c|
          if ((c.read_jobs || []).any?)
            tracker = c.get_or_create_read_tracker
            tracker.update(read_jobs: c.read_jobs.uniq)
            c.update(read_jobs: [])
          end
          
          if ((c.forum_read_posts || []).any?)
            tracker = c.get_or_create_read_tracker
            tracker.update(forum_read_posts: c.forum_read_posts.uniq)
            c.update(forum_read_posts: [])
          end
        end
     
      end
    end    
  end
end