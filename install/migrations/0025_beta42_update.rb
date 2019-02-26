module AresMUSH  
  module Migrations
    class MigrationBeta42Update
      def require_restart
        false
      end
      
      def migrate
        Global.logger.debug "Fixing forum read posts."
        
        Character.all.each do |c|
          c.update(forum_read_posts: c.forum_read_posts.map { |p| p.to_s }.uniq)
        end
        
        Global.logger.debug "Adding idle warn message."
        config = DatabaseMigrator.read_config_file("idle.yml")
        config['idle']['idle_warn_msg'] = "You haven't played in awhile and your character is in danger of idling out."
        DatabaseMigrator.write_config_file("idle.yml", config)  
        

      end
    end
  end
end
