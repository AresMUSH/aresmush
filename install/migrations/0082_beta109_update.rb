module AresMUSH  

  module Migrations
    class MigrationBeta109Update
      def require_restart
        true
      end
      
      def migrate

        Global.logger.debug "Add default boot timeout."
        config = DatabaseMigrator.read_config_file("login.yml")
        config['login']['boot_timeout_seconds'] = 300
        DatabaseMigrator.write_config_file("login.yml", config)     
        
        Global.logger.debug "Migrating discord config"
        config = DatabaseMigrator.read_config_file("secrets.yml")
        if (config['secrets']['discord'])
          (config['secrets']['discord']['webhooks'] || []).each do |hook|
            channel = Channel.named(hook['mush_channel'])
            if (!channel)
              Global.logger.debug "Channel #{hook['mush_channel']} not found!"
              next
            end
          
            channel.update(discord_channel: hook['discord_channel'])
            channel.update(discord_webhook: hook['webhook_url'])
          end
          config['secrets']['discord'].delete 'webhooks'
          DatabaseMigrator.write_config_file("secrets.yml", config)     
        end
        
        config = DatabaseMigrator.read_config_file("channels.yml")
        if (!config['channels']['discord_debug'])
          config['channels']['discord_debug'] = false
          config['channels'].delete 'discord_debug'
          DatabaseMigrator.write_config_file("channels.yml", config)
        end
        
      end
    end
  end    
end