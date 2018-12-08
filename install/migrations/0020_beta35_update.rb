module AresMUSH  
  class Room
    attribute :room_owner
  end
  
  module Migrations
    class MigrationBeta35Update
      def require_restart
        true
      end
      
      def migrate
        Global.logger.debug "Adding web submit flag."
        config = DatabaseMigrator.read_config_file("chargen.yml")
        config['chargen']['allow_web_submit'] = true
        DatabaseMigrator.write_config_file("chargen.yml", config)    
  
        Global.logger.debug "Adding achievement shortcut and custom achievements."
        config = DatabaseMigrator.read_config_file("achievements.yml")
        config['achievements']['shortcuts'] = { 'achievements' => 'achievement' }
        config['achievements']['custom_achievements'] = {}
        DatabaseMigrator.write_config_file("achievements.yml", config)    
    
        Global.logger.debug "Adding room owners shortcut."
        config = DatabaseMigrator.read_config_file("rooms.yml")
        config['rooms']['shortcuts']['owners'] = 'owner'
        DatabaseMigrator.write_config_file("rooms.yml", config)    
    
        Room.all.each do |r|
          if (r.room_owner)
            r.room_owners.replace [ Character[r.room_owner] ]
            r.update(room_owner: nil)
          end
        end
      end
    end
  end
end