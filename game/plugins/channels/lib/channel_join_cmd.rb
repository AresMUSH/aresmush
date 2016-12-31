module AresMUSH
  module Channels
    class ChannelJoinCmd
      include CommandHandler
           
      attr_accessor :name, :alias

      def crack!
        cmd.crack_args!(CommonCracks.arg1_equals_optional_arg2)
        self.name = titleize_input(cmd.args.arg1)
        self.alias = trim_input(cmd.args.arg2)
      end
          
      def required_args
        {
          args: [ self.name ],
          help: 'channels'
        }
      end
        
      def handle
        Channels.join_channel(self.name, client, enactor, self.alias)
      end
    end
  end
end
