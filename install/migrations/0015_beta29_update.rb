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
        
        Global.logger.debug "Adding approved channels."
        config = DatabaseMigrator.read_config_file("channels.yml")
        config['channels']['approved_channels'] = [ "RP Requests" ]
        DatabaseMigrator.write_config_file("channels.yml", config)    
      end
    end
  end
end