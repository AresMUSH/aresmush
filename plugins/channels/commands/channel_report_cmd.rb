module AresMUSH
  module Channels
    class ChannelReportCmd
      include CommandHandler
           
      attr_accessor :name, :reason
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.name = titlecase_arg(args.arg1)
        self.reason = args.arg2
      end
      
      def required_args
        [ self.name, self.reason ]
      end
      
      def handle
        Channels.with_an_enabled_channel(self.name, client, enactor) do |channel|
          Channels.report_channel_abuse(enactor, channel, channel.sorted_channel_messages.last(50), self.reason) 
          client.emit_success t('channels.channel_reported')
        end
      end
    end  
  end
end