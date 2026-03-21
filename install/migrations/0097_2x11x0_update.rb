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
        
        Global.logger.debug "Gear blurb."
        config = DatabaseMigrator.read_config_file("fs3combat_misc.yml")
        config['fs3combat']['gear_blurb'] = ""
        DatabaseMigrator.write_config_file("fs3combat_misc.yml", config)
        
        # Create system notices board if it doesn't exist
        notices_board = Global.read_config("achievements", "notification_category")
        if (!BbsBoard.find_one_by_name(notices_board))
          Global.logger.debug "Creating system notices board."
          board = BbsBoard.create(name: notices_board, description: "System messages.", order: BbsBoard.all.count)
          board.write_roles.add Role.find_one_by_name("admin")
          board.save
        end
        
      end
    end
  end    
end