module AresMUSH  

  module Migrations
    class MigrationBeta98Update
      def require_restart
        true
      end
      
      def migrate
        Global.logger.debug "Creating tags."

        if (ContentTag.all.count == 0)
          WikiPage.all.each do |p|
            Website.update_tags(p, p.tags)
          end
          Character.all.each do |c|
            Website.update_tags(c, c.profile_tags)
          end
          Scene.shared_scenes.each do |s|
            Website.update_tags(s, s.tags)
          end
          Event.all.each do |e|
            Website.update_tags(e, e.tags)
          end
        end
        
        Global.logger.debug "Adding xp aliases."
        config = DatabaseMigrator.read_config_file("fs3skills_misc.yml")
        config['fs3skills']['shortcuts']['xp/subtract'] = 'xp/remove'
        config['fs3skills']['shortcuts']['xp/add'] = 'xp/award'
        DatabaseMigrator.write_config_file("fs3skills_misc.yml", config)
        
        Global.logger.debug "Set default play screen."
        Character.all.each { |c| c.update(unified_play_screen: true)}
        
        Global.logger.debug "Combat messages."
        Combat.all.each { |c| c.update(messages: [])}
        
        
        Global.logger.debug "Wiki export cron."
        config = DatabaseMigrator.read_config_file("website.yml")
        config['website']['wiki_export_cron'] = { 'hour' => [3], 'minute' => [37] }
        DatabaseMigrator.write_config_file("website.yml", config)
        
        
      end
    end
  end    
end