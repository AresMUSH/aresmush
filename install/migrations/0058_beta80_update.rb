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
          
          if ((c.forum_read_posts || []).any?)
            tracker = c.get_or_create_read_tracker
            tracker.update(forum_read_posts: c.forum_read_posts.uniq)
            c.update(forum_read_posts: [])
          end
          
          if ((c.read_scenes || []).any?)
            tracker = c.get_or_create_read_tracker
            tracker.update(read_scenes: c.read_scenes.uniq)
            c.update(read_scenes: [])
          end
          
          if ((c.read_page_threads || []).any?)
            tracker = c.get_or_create_read_tracker
            tracker.update(read_page_threads: c.read_page_threads.uniq)
            c.update(read_page_threads: [])
          end
        end
     
      end
    end    
  end
end