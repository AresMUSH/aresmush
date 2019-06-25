module AresMUSH  
  class CookieAward < Ohm::Model
    include ObjectModel
    
    reference :giver, "AresMUSH::Character"
    reference :recipient, "AresMUSH::Character"
  end
  
  class Character
    attribute :total_cookies
  end
  
  module Migrations
    class MigrationBeta52Update
      def require_restart
        true
      end
      
      def migrate
        
        Global.logger.debug "Deleting cookie awards and initializing luck."
        CookieAward.all.each { |c| c.delete }
        Character.all.each do |c|
          c.update(fs3_cookie_archive: c.total_cookies)
          c.update(total_cookies: nil)
          c.update(fs3_scene_luck: {})
        end
        
        config = DatabaseMigrator.read_config_file("fs3skills_misc.yml")
        config['fs3skills']['luck_for_scene'] = {
          0 => 0.1,
          10 => 0.075,
          25 => 0.05,
          50 => 0.025
        }
        DatabaseMigrator.write_config_file("fs3skills_misc.yml", config)
        
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
      
      Global.logger.debug "Add inventory shortcuts."
      config = DatabaseMigrator.read_config_file("utils.yml")
      ['i', 'in', 'inv'].each do |sc|
        config['utils']['shortcuts'][sc] = "echo %% There's no inventory system here."
      end
      DatabaseMigrator.write_config_file("utils.yml", config)  
            
      Global.logger.debug "Update actor shortcut and property names."
      config = DatabaseMigrator.read_config_file("demographics.yml")
      config['demographics']['shortcuts']['actors'] = 'census played by'
      config['demographics']['shortcuts']['actor'] = 'demographic/set played by='
      config['demographics']['shortcuts']['fullname'] = 'demographic/set full name='
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
      end
      
      Global.logger.debug "Removing cookies plugin dir."
      cookies_dir = File.join(AresMUSH.root_path, "plugins/cookies")
      if (File.exist?(cookies_dir))
        FileUtils.remove_dir(cookies_dir)
      end
      
    end
  end
end
