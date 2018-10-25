module AresMUSH  
  module Migrations
    class MigrationBeta29Update
      def require_restart
        false
      end
      
      def migrate
        Global.logger.debug "Adding scene rooms."
        Scene.all.select { |s| !s.completed && !s.room }.each do |scene|
          Scenes.create_scene_temproom(scene)
        end
      end
    end
  end
end