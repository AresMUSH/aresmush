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
        Channels.join_channel(self.name, client, enactor, self.alias)
      end
    end
  end
end
