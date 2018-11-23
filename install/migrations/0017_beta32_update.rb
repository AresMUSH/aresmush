module AresMUSH  
  module Migrations
    class MigrationBeta32Update
      def require_restart
        false
      end
      
      def migrate
        Global.logger.debug "Adding default top nav."

        default_config = DatabaseMigrator.read_distr_config_file("website.yml")

        config = DatabaseMigrator.read_config_file("website.yml")
        config['website'].delete 'wiki_nav'
        config['website']['top_navbar'] = default_config['website']['top_navbar']
        DatabaseMigrator.write_config_file("website.yml", config)    
         
         
        Global.logger.debug "Adding private demographics"
        config = DatabaseMigrator.read_config_file("demographics.yml")
        config['demographics']['private_properties'] = []
        DatabaseMigrator.write_config_file("demographics.yml", config)    
        
        Global.logger.debug "Normalize group names"
        
        Character.all.each do |c|
          new_groups = {}
          if (c.groups)
            c.groups.each do |k, v|
              new_groups[k.downcase] = v
            end
          end
          c.update(groups: new_groups)
        end
        
      end
    end
  end
end