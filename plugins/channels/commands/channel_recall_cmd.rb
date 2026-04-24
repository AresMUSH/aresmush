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
          
          messages = channel.sorted_channel_messages
          .select { |m| Channels.is_message_visible?(enactor, m) }
          .last(self.num_messages)
          
          template = ChannelRecallTemplate.new(enactor, channel, messages)
          client.emit template.render
        end
      end
    end  
  end
end