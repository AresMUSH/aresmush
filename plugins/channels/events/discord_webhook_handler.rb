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
        
        debug_enabled = Global.read_config('channels', 'discord_debug')
        if (debug_enabled) 
          Global.logger.debug("Discord Message: user=#{user} nick=#{nickname} message=#{message} channel=#{discord_channel_name}")
        end
        
        if (Global.read_config('secrets', 'discord', 'api_token') != token)
          if (debug_enabled) 
            Global.logger.debug("Invalid discord API token.")
          end
          return { error: "Invalid channel API token." }
        end

        channel = Channel.all.select { |c| c.discord_channel == discord_channel_name }.first
        
        if (!channel)
          if (debug_enabled) 
            Global.logger.debug("No matching channel hook found for #{discord_channel_name}.")
          end
          return {}
        elsif debug_enabled
          Global.logger.debug("Discord #{discord_channel_name} matches #{channel.name}.")
        end
                
        prefix = Global.read_config('channels', 'discord_prefix') || "[D]"
        enactor = Character.named(name)
        Channels.emit_to_channel(channel, "#{prefix} #{name}: #{message}", title = nil)
      end
    end
  end
end