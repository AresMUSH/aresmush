module AresMUSH  

  module Migrations
    class MigrationBeta64Update
      def require_restart
        false
      end
      
      def migrate
        
        Global.logger.debug "Resetting word count achievement."
        Achievement.all.select { |a| a.name == "word_count" }.each { |a| a.delete }
        
        
        Global.logger.debug "Reset default log size."
        config = DatabaseMigrator.read_config_file("logger.yml")
        config['logger']['outputters'].each do |outputter|
          if (outputter['type'] == 'RollingFileOutputter')
            outputter['maxsize'] = 125000
            outputter['max_backups'] = 20
          end
        end
        DatabaseMigrator.write_config_file("logger.yml", config)
        
        
        Global.logger.debug "Migrate scene likes."
        Scene.all.each do |s|
          s.likers.each do |liker|
            next if !liker
            SceneLike.create(scene: s, character: liker)
          end
          s.likers.replace []
          
          if (s.completed)
            s.invited.replace []
            s.watchers.replace []
          end
        end
        
        Global.logger.debug "Reset default log size."
        config = DatabaseMigrator.read_config_file("scenes.yml")
        config['scenes']['idle_scene_timeout_days'] = 7
        DatabaseMigrator.write_config_file("scenes.yml", config)
        
        
      end 
    end
  end
end