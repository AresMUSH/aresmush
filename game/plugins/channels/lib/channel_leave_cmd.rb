module AresMUSH
  module Channels
    class ChannelLeaveCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
           
      attr_accessor :name

      def initialize
        self.required_args = ['name']
        self.help_topic = 'channels'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("channel") && cmd.switch_is?("leave")
      end
      
      def crack!
        self.name = titleize_input(cmd.args)
      end
      
      def handle
        Channels.with_an_enabled_channel(self.name, client) do |channel|
          Channels.leave_channel(client.char, channel)
        end
      end
    end
  end
end
