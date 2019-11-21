module AresMUSH  

  module Migrations
    class MigrationBeta64Update
      def require_restart
        true
      end
      
      def migrate
        
        Global.logger.debug "Resetting word count achievement."
        Achievement.all.select { |a| a.name == "word_count" }.each { |a| a.delete }
        Character.all.each do |c| 
          c.update(pose_word_count: 0 )
          c.update(scenes_participated_in: [] )
        end
        
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
        
        Global.logger.debug "FS3 incapable rename take 2."
        config = DatabaseMigrator.read_config_file("fs3skills_chargen.yml")
        if (config['fs3skills']['allow_incapable_action_skills'] == nil )
          config['fs3skills']['allow_incapable_action_skills'] = config['fs3skills']['allow_unskilled_action_skills']
          config['fs3skills'].delete 'allow_unskilled_action_skills'
          config = DatabaseMigrator.write_config_file("fs3skills_chargen.yml", config)
        end
        
      end 
    end
  end
end