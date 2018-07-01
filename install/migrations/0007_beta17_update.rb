module AresMUSH
  module Migrations
    class MigrationBeta17Update
      def require_restart
        false
      end
      
      def migrate
        
        Global.logger.debug "Scene pose divider and set shortcut."
        config = DatabaseMigrator.read_config_file("scenes.yml")
        config['scenes']['include_pose_separator'] = false
        config['scenes']['shortcuts']['scene/set'] = 'emit/set'
        DatabaseMigrator.write_config_file("scenes.yml", config)
        
        Global.logger.debug "Sitemap update."
        config = DatabaseMigrator.read_config_file("website.yml")
        config['website']['sitemap_update_cron'] = { 'hour' => [02], 'minute' => [17] }
        DatabaseMigrator.write_config_file("website.yml", config)
        
        Global.logger.debug "Creating room areas."
        Room.all.each do |r|
          next if !r.room_area
          area = Area.find_one_by_name(r.room_area)
          if (!area)
            area = Area.create(name: r.room_area)
          end
          r.update(area: area)
        end
        
        GameMap.all.each do |map|
          areas = map.areas ? map.areas.to_a : []
          areas << map.name
          areas.each do |area_name|
            area = Area.find_one_by_name(area_name)
            if (area)
              area.update(description: map.map_text)
            end
          end
        end
        
        config = DatabaseMigrator.read_config_file("rooms.yml")
        config['rooms']['shortcuts']['room/area'] = 'area/set'
        config['rooms']['shortcuts']['map'] = 'area'
        DatabaseMigrator.write_config_file("rooms.yml", config)
        
        
      end
    end
  end
end