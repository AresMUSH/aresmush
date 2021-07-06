module AresMUSH  

  module Migrations
    class MigrationBeta98Update
      def require_restart
        true
      end
      
      def migrate
        Global.logger.debug "Creating tags."

        WikiPage.all.each do |p|
          Website.update_tags(p, p.tags)
        end
        Character.all.each do |c|
          Website.update_tags(c, c.profile_tags)
        end
        Scene.shared_scenes.each do |s|
          Website.update_tags(s, s.tags)
        end
        Event.all.each do |e|
          Website.update_tags(e, e.tags)
        end
      end
    end
  end    
end