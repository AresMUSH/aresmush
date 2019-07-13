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
        
        Global.logger.debug "Adding ids to channel recall messages."
        Channel.all.each do |c|
          messages = c.messages
          messages.each do |m|
            m['id'] = SecureRandom.uuid
          end
          c.update(messages: messages)
        end
        
        Global.logger.debug "Default icon blurb."
        config = DatabaseMigrator.read_config_file("chargen.yml")
        config['chargen']['icon_blurb'] = "Your profile icon appears in scenes and the character gallery to show your character at a glance. Providing a profile icon is optional. You can upload additional character images once you're approved."
        config = DatabaseMigrator.write_config_file("chargen.yml", config)
        
        Global.logger.debug "Clearing out zombie friends."
        Friendship.all.select { |f| !f.friend }.each { |f| f.delete }
        
        Global.logger.debug "Clearing recent changes."
        Game.master.update(recent_changes: [])
        
      end 
    end
  end
end