module AresMUSH  

  module Migrations
    class MigrationBeta94Update
      def require_restart
        false
      end
      
      def migrate
        
        Global.logger.debug "Adding achievement levels."
        config = DatabaseMigrator.read_config_file("scenes.yml")
        achievements = config['scenes']['achievements']
        if (achievements['word_count'])
          achievements['word_count']['levels'] = [ 1000, 2000, 5000, 10000, 25000, 50000, 100000, 250000, 500000, 750000, 1000000, 1250000, 1500000, 1750000, 2000000, 2250000, 2500000, 2750000, 3000000 ]
        end
        if (achievements['scene_participant'])
          achievements['scene_participant']['levels'] = [ 1, 10, 20, 50, 100, 200, 300, 400, 500, 600, 700, 800, 900, 1000, 1500, 2000, 2500, 3000, 3500, 4000, 4500, 5000 ]
        end
        DatabaseMigrator.write_config_file("scenes.yml", config)

        config = DatabaseMigrator.read_config_file("fs3combat_misc.yml")
        achievements = config['fs3combat']['achievements']
        if (achievements['fs3_joined_combat'])
          achievements['fs3_joined_combat']['levels'] = [ 1, 10, 20, 50, 100, 200, 500, 1000 ]
        end
        if (achievements['fs3_wounded'])
          achievements['fs3_wounded']['levels'] = [ 1, 5, 10, 20, 50, 100, 150, 200, 250, 500 ]
        end
        DatabaseMigrator.write_config_file("fs3combat_misc.yml", config)
        
      end
    end    
  end
end