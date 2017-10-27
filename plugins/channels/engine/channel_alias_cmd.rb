module AresMUSH
  module Channels
    class ChannelAliasCmd
      include CommandHandler
           
      attr_accessor :name, :alias

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.name = titlecase_arg(args.arg1)
        self.alias = trim_arg(args.arg2)
      end
      
      def required_args
        [ self.name, self.alias ]
      end
      
      def handle
        Channels.with_an_enabled_channel(self.name, client, enactor) do |channel|
          Channels.set_channel_alias(client, enactor, channel, self.alias)
        end
      end
    end  
  end
end