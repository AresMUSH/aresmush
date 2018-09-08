module AresMUSH  
  module Migrations
    class MigrationBeta22Update
      def require_restart
        false
      end
      
      def migrate
        
        Global.logger.debug "Removing chat shortcut."
        config = DatabaseMigrator.read_config_file("channels.yml")
        config['channels']['shortcuts'].delete('chat')
        DatabaseMigrator.write_config_file("channels.yml", config)   
        
        
        Global.logger.debug "Default channels to show titles."
        ChannelOptions.all.each do |c|
          c.update(show_titles: true)
        end
        
        Global.logger.debug "Configurable chargen tips."
        config = DatabaseMigrator.read_config_file("chargen.yml")
        config['chargen']['bg_blurb'] = "You don't need to write a novel. Just cover the basics: who you are, why are you here, and is there anything noteworthy about you. Be sure to explain any unusual skills."
        config['chargen']['hooks_blurb'] = "RP Hooks are interesting things about your character that others can hook into for RP. This could be an odd personality quirk, a reputation your character has, or anything else that might inspire someone to connect with you. Looking around at other character's sheets can be a good way to get inspiration for RP Hooks."
        config['chargen']['desc_blurb'] = "You can set both your main description, visible when people look at you, and a short description that shows your character at a glance."
        DatabaseMigrator.write_config_file("chargen.yml", config)   
                
      end
    end
  end
end