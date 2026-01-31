module AresMUSH  

  module Migrations
    class Migration2x11x0Update
      def require_restart
        false
      end
      
      def migrate
        Global.logger.debug "Default wiki folders."
        config = DatabaseMigrator.read_config_file("website.yml")
        config['website']['public_wiki_folders'] = [ "misc" ]
        config['website']['default_public_folder'] = "misc"
        DatabaseMigrator.write_config_file("website.yml", config)
      end
    end
  end    
end