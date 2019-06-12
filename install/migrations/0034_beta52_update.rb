module AresMUSH  
  module Migrations
    class MigrationBeta52Update
      def require_restart
        true
      end
      
      def migrate
        Global.logger.debug "Removing actors from web menu."
        config = DatabaseMigrator.read_config_file("website.yml")
        menu = config['website']['top_navbar']
        menu.each do |submenu|
          submenu['menu'].each do |item|
            if item['route'] == 'actors'
              submenu['menu'].delete item
            end
          end
        end
        DatabaseMigrator.write_config_file("website.yml", config)
      end
      
      Global.logger.debug "Update actor shortcut."
      config = DatabaseMigrator.read_config_file("demographics.yml")
      config['demographics']['shortcuts']['actors'] = 'census played by'
      DatabaseMigrator.write_config_file("demographics.yml", config)  
      
      
      Global.logger.debug "Renaming actor to played by."
      Character.all.each do |c|
        c.update_demographic('played by', c.demographic('actor'))
        c.update_demographic('actor', nil)
      end
    end
  end
end
