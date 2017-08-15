module AresMUSH
  module Channels
    class ChannelLeaveCmd
      include CommandHandler
           
      attr_accessor :name
      
      def parse_args
        self.name = titlecase_arg(cmd.args)
      end
      
      def required_args
        [ self.name ]
      end
      
      def handle
        Channels.with_an_enabled_channel(self.name, client, enactor) do |channel|
          Channels.leave_channel(enactor, channel)
        end
      end
    end
  end
end
