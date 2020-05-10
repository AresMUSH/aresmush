module AresMUSH
  module Channels
    class DiscordWebhookHandler
      def handle(request)
        token = request.args['token'] || ""
        name = request.args['nickname'] || ( request.args['user'] || "" )
        message = request.args['message'] || ""
        discord_channel_name = request.args['channel'] || ""
        
        if (Global.read_config('secrets', 'discord', 'api_token') != token)
          return { error: "Invalid channel API token." }
        end
        
        hook = (Global.read_config('secrets', 'discord', 'webhooks') || {})
           .select { |h| (h['discord_channel'] || "").upcase == discord_channel_name.upcase }
           .first
        
        if (!hook)
          return {}
        end
        
        mush_channel_name = hook['mush_channel']
        channel = Channel.named(mush_channel_name)
        if (!channel)
          return { error: t('channels.channel_doesnt_exist', :name => mush_channel_name) }
        end
        
        prefix = Global.read_config('channels', 'discord_prefix') || "[D]"
        enactor = Character.named(name)
        Channels.emit_to_channel(channel, "#{prefix} #{name}: #{message}", title = nil)
      end
    end
  end
end