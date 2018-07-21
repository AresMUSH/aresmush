module AresMUSH
  module Channels
    class ChannelJoinCmd
      include CommandHandler
           
      attr_accessor :name, :alias

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_optional_arg2)
        self.name = titlecase_arg(args.arg1)
        self.alias = trim_arg(args.arg2)
      end
          
      def required_args
        [ self.name ]
      end
        
      def handle
        Channels.with_a_channel(self.name, client) do |channel|
          error = Channels.join_channel(channel, enactor, self.alias)
          if (error)
            client.emit_failure error
          else
            options = Channels.get_channel_options(enactor, channel)
            client.emit_ooc options.alias_hint
          end
        end
      end
    end
  end
end
