module AresMUSH
  module Channels
    class ChannelRecallCmd
      include CommandHandler
           
      attr_accessor :name, :num_messages
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_optional_arg2)
        self.name = args.arg1
        self.num_messages = integer_arg(args.arg2) || 25
      end
      
      def required_args
        [ self.name ]
      end
      
      def check_number
        return t('channels.invalid_recall_limit') if self.num_messages < 1
        return t('channels.invalid_recall_limit') if self.num_messages > 25
        return nil
      end
      
      def handle
        Channels.with_an_enabled_channel(self.name, client, enactor) do |channel|
          total_messages = channel.messages.count
          start_message = [ (total_messages - self.num_messages), 0 ].max
          messages = channel.messages[start_message, total_messages].map { |m| " #{channel.display_name} #{m}" }

          template = BorderedListTemplate.new messages, t('channels.recall_history', :name => channel.display_name(false))
          client.emit template.render
        end
      end
    end  
  end
end