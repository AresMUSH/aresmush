module AresMUSH  
  module Migrations
    class MigrationBeta48Update
      def require_restart
        false
      end
      
      def migrate
        Global.logger.debug "New page config."
        config = DatabaseMigrator.read_config_file("page.yml")
        config['page']['page_deletion_days'] = 60
        config['page']['page_deletion_cron'] = { 'day_of_week' => ['Wed'], 'hour' => [03], 'minute' => [40] }
        config['page']['shortcuts']['page/log'] = 'page/review'
        DatabaseMigrator.write_config_file("page.yml", config)  
                
        Global.logger.debug "Update forum shortcuts."
        config = DatabaseMigrator.read_config_file("forum.yml")
        config['forum']['shortcuts']['bbnewgroup'] = 'forum/createcat'
        config['forum']['shortcuts']['bbs/newgroup'] = 'forum/createcat'
        config['forum']['shortcuts']['bbcleargroup'] = 'forum/deletecat'
        DatabaseMigrator.write_config_file("forum.yml", config)  
        
        Global.logger.debug "New chargen blurbs."
        config = DatabaseMigrator.read_config_file("chargen.yml")
        config['chargen']['groups_blurb'] = "Groups determine your character's affiliations."
        config['chargen']['demographics_blurb'] = "Demographics record your basic character info."
        config['chargen']['rank_blurb'] = "Military rank."
        DatabaseMigrator.write_config_file("chargen.yml", config)  

        Global.logger.debug "Roster display config."
        config = DatabaseMigrator.read_config_file("idle.yml")
        config['idle']['roster_fields'] = 
        [
          { 'field' => 'name', 'width' => 28, 'title' => 'Name' },
          { 'field' => 'demographic', 'width' => 10, 'title' => 'Gender', 'value' => 'gender' },
          { 'field' => 'group', 'width' => 20, 'title' => 'Faction', 'value' => 'Faction' },
          { 'field' => 'group', 'width' => 20, 'title' => 'Position', 'value' => 'Position' }
        ]
        DatabaseMigrator.write_config_file("idle.yml", config)  
        
        Character.all.each do |c|
          c.update(read_page_threads: [])
        end
      end
    end
  end
end
