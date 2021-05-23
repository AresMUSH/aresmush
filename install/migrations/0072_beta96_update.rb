module AresMUSH  

  module Migrations
    class MigrationBeta96Update
      def require_restart
        false
      end
      
      def migrate
        
        Global.logger.debug "Adding achievement levels."
        
        if (File.exist?(File.join(AresMUSH.game_path, 'config', 'cookies.yml')))
          config = DatabaseMigrator.read_config_file("cookies.yml")
          achievements = config['cookies']['achievements']
          if (achievements['cookie_given'])
            achievements['cookie_given']['levels'] = [1, 10, 25, 50, 100, 200, 500, 1000]
            achievements['cookie_given']['message'] = "Gave %{count} cookies."
          end
          if (achievements['cookie_received'])
            achievements['cookie_received']['levels'] = [1, 10, 25, 50, 100, 200, 500, 1000]
          end
          DatabaseMigrator.write_config_file("cookies.yml", config)          
        end
      end
    end    
  end
end