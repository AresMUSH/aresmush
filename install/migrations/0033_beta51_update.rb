module AresMUSH  
  module Migrations
    class MigrationBeta51Update
      def require_restart
        false
      end
      
      def migrate
        Global.logger.debug "Updating web menu."
        config = DatabaseMigrator.read_config_file("website.yml")
        menu = config['website']['top_navbar']
        new_menu = []
        menu.each do |submenu|
          new_submenu = {}
          new_submenu['title'] = submenu['title']
          new_submenu['menu'] = []
          submenu['menu'].each do |item|
            if item['page']
              item['route'] = item['page']
              item.delete 'page'
            end
            new_submenu['menu'] << item
          end
          new_menu << new_submenu
        end
        DatabaseMigrator.write_config_file("website.yml", config)  
        
        PageThread.all.each do |t|
          if (t.page_messages.count == 0)
            t.delete
          end
        end
      end
    end
  end
end
