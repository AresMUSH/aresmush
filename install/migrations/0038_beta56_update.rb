module AresMUSH  

  module Migrations
    class MigrationBeta56Update
      def require_restart
        false
      end
      
      def migrate
        
        if (!Channel.named("Game"))
          channel = AresMUSH::Channel.create(name: "Game",
             color: "%xh",
             description: "Game notifications.")
          channel.default_alias = [ 'game' ]
          channel.save
          Character.all.each { |c| Channels.join_channel(channel, c, "game")}
        end
        
        Global.logger.debug "Default announce channel."
        config = DatabaseMigrator.read_config_file("channels.yml")
        config['channels']['announce_channel'] = 'Game'
        config = DatabaseMigrator.write_config_file("channels.yml", config)
        
      end 
    end
  end
end