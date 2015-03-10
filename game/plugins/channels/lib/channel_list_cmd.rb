module AresMUSH
  module Channels
    class ChannelListCmd
      include Plugin
      include PluginRequiresLogin
      include PluginWithoutArgs
      include TemplateFormatters
           
      def want_command?(client, cmd)
        cmd.root_is?("channels") || (cmd.root_is?("channel") && cmd.switch_is?("list"))
      end
      
      def handle        
        all_channels = Channel.all.sort { |c1, c2| c1.name <=> c2.name }
        
        output = "%xh#{t('channels.channels_title')}%xn%r%l2%r"
        output << all_channels.map { |c| channel_list_entry(c) }.join("%r")
        output << "%R%R%l2%R"
        output << t('channels.channel_aliases')
        all_channels.each do |channel|
          if (Channels.is_on_channel?(client.char, channel))
            aliases = Channels.get_channel_option(client.char, channel, 'alias')
            aliases.each do |a|
              output << "%R%T#{channel.color}#{a} <message>%xn talks on #{channel.display_name(false)}."
            end
          end
        end
        client.emit BorderedDisplay.text(output)
      end
      
      def channel_list_entry(channel)
        name = left(channel.display_name(false),25)
        desc = left(channel.description,25)
        roles = channel.roles.join(" ")
        announce = channel.announce ? " +   " : " -   "
        on = Channels.is_on_channel?(client.char, channel) ? "(+)" : "(-)"
        "#{on} #{name} #{desc} #{announce}   #{roles}"
      end
    end
  end
end
