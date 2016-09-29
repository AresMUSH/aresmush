module AresMUSH
  module Channels
    class ChannelJoinCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
           
      attr_accessor :name, :alias

      def initialize(client, cmd, enactor)
        self.required_args = ['name']
        self.help_topic = 'channels'
        super
      end
      
      def crack!
        cmd.crack_args!(CommonCracks.arg1_equals_optional_arg2)
        self.name = titleize_input(cmd.args.arg1)
        self.alias = trim_input(cmd.args.arg2)
      end
            
      def handle
        Channels.join_channel(self.name, client, enactor, self.alias)
      end
    end
  end
end
