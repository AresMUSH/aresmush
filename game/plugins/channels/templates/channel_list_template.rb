module AresMUSH
  module Channels
    class ChannelListTemplate < AsyncTemplateRenderer
      include TemplateFormatters
      
      def initialize(channels, client)
        @channels = channels
        super client
      end
      
      def build
        output = "%xh#{t('channels.channels_title')}%xn%r%l2%r"
        output << @channels.map { |c| channel_list_entry(c) }.join("%r")
        output << "%R%l2%R"
        output << t('channels.channel_aliases')
        @channels.each do |channel|
          if (Channels.is_on_channel?(self.client.char, channel))
            aliases = Channels.get_channel_option(self.client.char, channel, 'alias')
            aliases.each do |a|
              output << "%R%T#{channel.color}#{a} <message>%xn talks on #{channel.display_name(false)}."
            end
          end
        end
        BorderedDisplay.text(output)
      end
      
      def channel_list_entry(channel)
        name = left(channel.display_name(false),25)
        desc = left(channel.description,25)
        roles = channel.roles.join(" ")
        announce = channel.announce ? " +   " : " -   "
        on = Channels.is_on_channel?(self.client.char, channel) ? "(+)" : "(-)"
        "#{on} #{name} #{desc} #{announce}   #{roles}"
      end
    end
  end
end