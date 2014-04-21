module AresMUSH
  module Channels
    class ChannelListCmd
      include Plugin
      include PluginRequiresLogin
      include PluginWithoutArgs
      include PluginWithoutSwitches
      include TemplateFormatters
           
      def want_command?(client, cmd)
        cmd.root_is?("channels")
      end
      
      def handle        
        channels = Channel.all.sort { |c1, c2| c1.name <=> c2.name }
        channels = channels.map { |c| channel_list_entry(c) }

        output = "%xh#{t('channels.channels_title')}%xn%r%l2%r"
        output << channels.join("%r")

        client.emit BorderedDisplay.text(output, t('channels.channels'))
      end
      
      def channel_list_entry(channel)
        name = left(channel.display_name(false),20)
        if (channel.characters.include?(client.char))
          status = "+"
        else
          status = ""
        end
        channel_alias = Channels.get_channel_option(client.char, channel, 'alias')
        channel_alias = "#{channel_alias}".ljust(8)
        status = status.ljust(4)
        desc = left(channel.description,26)
        roles = channel.roles.join(" ")
        "#{name} #{status} #{channel_alias} #{desc} #{roles}"
      end
    end
  end
end
