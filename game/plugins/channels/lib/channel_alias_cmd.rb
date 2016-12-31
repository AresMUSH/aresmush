module AresMUSH
  module Channels
    class ChannelAliasCmd
      include CommandHandler
           
      attr_accessor :name, :alias

      def crack!
        cmd.crack_args!(ArgParser.arg1_equals_arg2)
        self.name = titleize_input(cmd.args.arg1)
        self.alias = trim_input(cmd.args.arg2)
      end
      
      def required_args
        {
          args: [ self.name, self.alias ],
          help: 'channels'
        }
      end
      
      def handle
        Channels.with_an_enabled_channel(self.name, client, enactor) do |channel|
          Channels.set_channel_alias(client, enactor, channel, self.alias)
        end
      end
    end  
  end
end