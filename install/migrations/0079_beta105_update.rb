module AresMUSH  

  module Migrations
    class MigrationBeta105Update
      def require_restart
        false
      end
      
      def migrate
        Global.logger.debug "Moving banned and suspect sites."
        config = DatabaseMigrator.read_config_file("sites.yml")
        
        if (config['sites']['banned'])
          banned = {}
          config['sites']['banned'].each do |site|
            banned["#{site}"] = ''
          end
      
          config['sites']['banned_archive'] = config['sites']['banned']
          
          Game.master.update(banned_sites: banned)
          config['sites'].delete 'banned'
          DatabaseMigrator.write_config_file("sites.yml", config)     


          Global.logger.debug "Default unified play."
          Character.all.each { |c| c.update(unified_play: true) }

        end
      end
    end
  end    
end