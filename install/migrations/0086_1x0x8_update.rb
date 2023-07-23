module AresMUSH  

  module Migrations
    class Migration1x0x8Update
      def require_restart
        false
      end
      
      def migrate
        Global.logger.debug "Add scene trash timeout and recycle option."
        config = DatabaseMigrator.read_config_file("scenes.yml")
        config['scenes']['scene_trash_timeout_days'] = 14
        config['scenes']['delete_scenes_on_idle_out'] = false
        config['scenes'].delete('unshared_scene_deletion_days')
        DatabaseMigrator.write_config_file("scenes.yml", config)  
      end
    end
  end    
end