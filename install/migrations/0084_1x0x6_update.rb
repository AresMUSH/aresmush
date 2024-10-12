module AresMUSH  

  module Migrations
    class Migration1x0x6Update
      def require_restart
        false
      end
      
      def migrate
        Global.logger.debug "Add searchbox config."
        config = DatabaseMigrator.read_config_file("website.yml")
        config['website']['hide_searchbox'] = false
        DatabaseMigrator.write_config_file("website.yml", config)  

        Global.logger.debug "Add area config."
        config = DatabaseMigrator.read_config_file("rooms.yml")
        config['rooms']['area_directory_order'] = []
        config['rooms']['icon_types'] = { "star" => "fas fa-star" }
        DatabaseMigrator.write_config_file("rooms.yml", config)  
      end
    end
  end    
end