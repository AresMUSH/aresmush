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
      
      Global.logger.debug "Update actor shortcut and property names."
      config = DatabaseMigrator.read_config_file("demographics.yml")
      config['demographics']['shortcuts']['actors'] = 'census played by'
      
      ['editable_properties', 'required_properties', 'demographics', 'private_properties'].each do |section|
        new_section = []
        config['demographics'][section].each do |item|
          if (item == 'actor')
            new_section << 'played by'
          elsif (item == 'fullname')
            new_section << 'full name'
          else
            new_section << item
          end
        end
        config['demographics'][section] = new_section
      end
      DatabaseMigrator.write_config_file("demographics.yml", config)  
      
      
      Global.logger.debug "Renaming actor to played by."
      Character.all.each do |c|
        c.update_demographic('played by', c.demographic('actor'))
        c.update_demographic('full name', c.demographic('fullname'))
        c.update_demographic('actor', nil)
        c.update_demographic('fullname', nil)
      end
    end
  end
end
