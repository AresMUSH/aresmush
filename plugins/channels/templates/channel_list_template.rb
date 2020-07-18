module AresMUSH
  module Channels
    class ChannelListTemplate < ErbTemplateRenderer
      
      attr_accessor :channels
      
      def initialize(channels, enactor)
        @channels = channels
        @enactor = enactor
        super File.dirname(__FILE__) + "/channel_list.erb"        
      end
      
      def channel_name(channel)
        Channels.display_name(@enactor, channel, false)
      end
      
      def channel_roles(channel)
        talk = channel.talk_roles.empty? ? t("channels.everyone") : channel.talk_roles.map {|r| r.name}.join(" ")
        join = channel.join_roles.empty? ? t("channels.everyone") : channel.join_roles.map {|r| r.name}.join(" ")

        "#{join} / #{talk}"
      end
      
      def channel_announce(channel)
        announce = Channels.announce_enabled?(@enactor, channel)
        announce ? "+" : " -   "
      end
      
      def channel_on_indicator(channel)
        return "(X)" if Channels.is_muted?(@enactor, channel)
        is_on_channel?(channel) ? "(+)" : "( )"
      end
      
      def is_on_channel?(channel)
        Channels.is_on_channel?(@enactor, channel) 
      end
      
      def channel_alias(channel)
        options = Channels.get_channel_options(@enactor, channel)
        (options.aliases || []).join(", ")
      end
      
      def channel_color(channel)
        Channels.channel_color(@enactor, channel)
      end
    end
  end
end