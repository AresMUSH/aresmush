module AresMUSH  
  module Migrations
    class MigrationBeta25Update
      def require_restart
        false
      end
      
      def migrate
        
        Global.logger.debug "Removing extra scene achievements."
        Achievement.all.each do |a|
          if (a.name =~ /scene_participant/)
            a.delete
          end
        end
        Character.all.each { |c| Scenes.handle_scene_participation_achievement(c) }
        
        config = DatabaseMigrator.read_config_file("demographics.yml")
        config['demographics']['census_fields'] = 
        [
          { 'field' => 'name', 'width' => 28, 'title' => 'Name' },
          { 'field' => 'demographic', 'width' => 10, 'title' => 'Gender', 'value' => 'gender' },
          { 'field' => 'group', 'width' => 20, 'title' => 'Faction', 'value' => 'Faction' },
          { 'field' => 'group', 'width' => 20, 'title' => 'Position', 'value' => 'Position' }
        ]
        DatabaseMigrator.write_config_file("demographics.yml", config)    
        
      end
    end
  end
end