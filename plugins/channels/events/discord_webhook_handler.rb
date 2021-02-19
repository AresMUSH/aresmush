module AresMUSH
  module Channels
    class DiscordWebhookHandler
      def handle(request)
        user = request.args['user'] || ""
        nickname = request.args['nickname']
        
        token = request.args['token'] || ""
        name = nickname || user 
        message = request.args['message'] || ""
        discord_channel_name = request.args['channel'] || ""
        
        debug_enabled = Global.read_config('channels', 'debug_discord')
        if (debug_enabled) 
          Global.logger.debug("Discord Message: user=#{user} nick=#{nickname} message=#{message} channel=#{discord_channel_name}")
        end
        
        if (Global.read_config('secrets', 'discord', 'api_token') != token)
          if (debug_enabled) 
            Global.logger.debug("Invalid discord API token.")
          end
          return { error: "Invalid channel API token." }
        end
        
        hook = (Global.read_config('secrets', 'discord', 'webhooks') || {})
           .select { |h| (h['discord_channel'] || "").upcase == discord_channel_name.upcase }
           .first
        
        if (!hook)
          if (debug_enabled) 
            Global.logger.debug("No matching channel hook found.")
          end
          return {}
        end
        
        mush_channel_name = hook['mush_channel']
        channel = Channel.named(mush_channel_name)
        if (!channel)
          if (debug_enabled) 
            Global.logger.debug("Channel not found: #{mush_channel_name}.")
          end
          
          return { error: t('channels.channel_doesnt_exist', :name => mush_channel_name) }
        end
        
        prefix = Global.read_config('channels', 'discord_prefix') || "[D]"
        enactor = Character.named(name)
        Channels.emit_to_channel(channel, "#{prefix} #{name}: #{message}", title = nil)
      end
    end
  end
end