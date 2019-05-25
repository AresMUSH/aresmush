module AresMUSH  
  module Migrations
    class MigrationBeta50Update
      def require_restart
        true
      end
      
      def migrate
        Global.logger.debug "Clearing zombie sets."
        Channel.all.each do |c|
          replace_zombies(c.characters)
        end
        Scene.all.each do |s|
          replace_zombies(s.likers)
          replace_zombies(s.invited)
          replace_zombies(s.participants)
          replace_zombies(s.watchers)
        end
        Character.all.each do |c|
          replace_zombies(c.page_ignored)
        end
        Room.all.each do |r|
          replace_zombies(r.room_owners)
        end
      end
      
      def replace_zombies(set)
        if (set.any? { |char| !char.name })
          set.replace(set.select { |char| char.name })
        end
      end
    end
  end
end
