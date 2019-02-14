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

      end
    end
  end
end
