module AresMUSH  
  
  class BbsPost
    set :readers, "AresMUSH::Character"
  end
    
  class Job
    set :readers, "AresMUSH::Character"
  end
  
  class Scene
    set :readers, "AresMUSH::Character"
  end
  
  module Migrations
    class MigrationBeta41Update
      def require_restart
        false
      end
      
      def migrate
        Global.logger.debug "Adding channel recall size."
        config = DatabaseMigrator.read_config_file("channels.yml")
        config['channels']['recall_buffer_size'] = 500
        DatabaseMigrator.write_config_file("channels.yml", config)  
        
        Global.logger.debug "Adding motd alias."
        config = DatabaseMigrator.read_config_file("login.yml")
        config['login']['shortcuts']['motd'] = 'notice/motd'
        DatabaseMigrator.write_config_file("login.yml", config)  
        
        
        Character.all.each do |c| 
          if (!c.forum_read_posts)
            c.update(forum_read_posts: [])
          end
          if (!c.read_jobs)
            c.update(read_jobs: [])
          end
          if (!c.read_scenes)
            c.update(read_scenes: [])
          end
        end
        BbsPost.all.each do |post|
          post.readers.each do |reader|
            Forum.mark_read(post, reader)
          end
          post.readers.replace []
        end
        Job.all.each do |job|
          job.readers.each do |reader|
            Jobs.mark_read(job, reader)
          end
          job.readers.replace []
        end
      end
    end
  end
end
