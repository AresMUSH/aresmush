module AresMUSH  

  module Migrations
    class MigrationBeta98Update
      def require_restart
        false
      end
      
      def migrate
        Global.logger.debug "Creating tags."

        WikiPage.all.each do |p|
          Website.update_tags('wiki', p.id, p.tags)
        end
        Character.all.each do |c|
          Website.update_tags('char', c.id, c.profile_tags)
        end
        Scene.shared_scenes.each do |s|
          Website.update_tags('scene', s.id, s.tags)
        end
        Event.all.each do |e|
          Website.update_tags('event', e.id, e.tags)
        end
      end
    end
  end    
end