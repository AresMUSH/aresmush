module AresMUSH  
  class Scene
    set :muters, "AresMUSH::Character"
  end
  
  module Migrations
    class MigrationBeta44Update
      def require_restart
        false
      end
      
      def migrate
        
        Global.logger.debug "Adding update shortcut."
        config = DatabaseMigrator.read_config_file("manage.yml")
        config['manage']['shortcuts']['update'] = 'upgrade'
        DatabaseMigrator.write_config_file("manage.yml", config)  
        
        Global.logger.debug "Cleaning up scene muters and watchers."
        Scene.all.each do |s|
          s.participants.each do |p|
            next if !p
            if (!s.watchers.include?(p) && !s.muters.include?(p))
              s.watchers.add p
            end
          end
          s.muters.replace []
        end
        
      end
    end
  end
end
