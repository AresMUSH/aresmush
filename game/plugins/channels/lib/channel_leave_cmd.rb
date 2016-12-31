module AresMUSH
  module Channels
    class ChannelLeaveCmd
      include CommandHandler
           
      attr_accessor :name
      
      def crack!
        self.name = titleize_input(cmd.args)
      end
      
      def required_args
        {
          args: [ self.name ],
          help: 'channels'
        }
      end
      
      def handle
        Channels.with_an_enabled_channel(self.name, client, enactor) do |channel|
          Channels.leave_channel(enactor, channel)
        end
      end
    end
  end
end
