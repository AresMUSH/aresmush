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
        channel.display_name(false)
      end
      
      def channel_roles(channel)
        channel.roles.map {|r| r.name}.join(" ")
      end
      
      def channel_announce(channel)
        announce = Channels.announce_enabled?(@enactor, channel)
        announce ? " +   " : " -   "
      end
      
      def channel_on_indicator(channel)
        return "(X)" if Channels.is_muted?(@enactor, channel)
        is_on_channel?(channel) ? "(+)" : "(-)"
      end
      
      def is_on_channel?(channel)
        Channels.is_on_channel?(@enactor, channel) 
      end
      
      def channel_alias(channel)
        options = Channels.get_channel_options(@enactor, channel)
        options.alias_hint
      end      
    end
  end
end