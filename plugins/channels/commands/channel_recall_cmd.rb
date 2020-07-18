module AresMUSH
  module Channels
    class ChannelRecallCmd
      include CommandHandler
           
      attr_accessor :name, :num_messages
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_optional_arg2)
        self.name = args.arg1
        self.num_messages = integer_arg(args.arg2) || 50
      end
      
      def required_args
        [ self.name ]
      end
      
      def check_number
        return t('channels.invalid_recall_limit') if self.num_messages < 1
        return t('channels.invalid_recall_limit') if self.num_messages > 50
        return nil
      end
      
      def handle
        Channels.with_an_enabled_channel(self.name, client, enactor) do |channel|
          messages = channel.sorted_channel_messages.last(self.num_messages)
          list = messages.map { |m| " [#{OOCTime.local_long_timestr(enactor, m.created_at)}] #{Channels.display_name(enactor, channel)}  #{m.message}"}
          template = BorderedListTemplate.new list, 
              t('channels.recall_history', :name => Channels.display_name(enactor, channel, false)), 
              "%R%ld%R#{t('channels.more_on_portal')}"
          client.emit template.render
        end
      end
    end  
  end
end