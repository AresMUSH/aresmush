module AresMUSH
  module Channels
    class ChannelRecallTemplate < ErbTemplateRenderer
      
      attr_accessor :channel, :enactor, :messages
      
      def initialize(enactor, channel, messages)
        @channel = channel
        @enactor = enactor
        @messages = messages
        super File.dirname(__FILE__) + "/channel_recall.erb"        
      end
      
      def title
        t('channels.recall_history', :name => Channels.display_name(self.enactor, self.channel, false))
      end
      
      def display_name
        Channels.display_name(self.enactor, self.channel)
      end
      
      def timestamp(message)
        OOCTime.local_long_timestr(self.enactor, message.created_at)
      end
      
      def message_flag(message)
        message.flagged ? "%xr[FLAGGED!] " : ""
      end
      
      
    end
  end
end