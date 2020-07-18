module AresMUSH
  module Channels
    class ChannelInfoTemplate < ErbTemplateRenderer
      
      attr_accessor :channel
      
      def initialize(channel, enactor)
        @channel = channel
        @enactor = enactor
        super File.dirname(__FILE__) + "/channel_info.erb"        
      end
      
      def display_name
        Channels.display_name(@enactor, @channel, false)
      end
      
      def talk_roles
        @channel.talk_roles.empty? ? t("channels.everyone") : @channel.talk_roles.map {|r| r.name.titlecase }.join(" ")
      end
      
      def join_roles
        @channel.join_roles.empty? ? t("channels.everyone") : @channel.join_roles.map {|r| r.name.titlecase }.join(" ")
      end
      
      def announce
        Channels.announce_enabled?(@enactor, channel).yesno
      end
      
      def aliases
        options = Channels.get_channel_options(@enactor, @channel)
        if (options)
          options.alias_hint
        else
          nil
        end
      end  
      
      def color
        Channels.channel_color(@enactor, @channel)
      end  
    end
  end
end