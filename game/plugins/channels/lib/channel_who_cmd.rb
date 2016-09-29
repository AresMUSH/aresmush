module AresMUSH
  module Channels
    class ChannelWhoCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
           
      attr_accessor :name

      def initialize(client, cmd, enactor)
        self.required_args = ['name']
        self.help_topic = 'channels'
        super
      end
            
      def crack!
        self.name = titleize_input(cmd.args)
      end
      
      def handle
        Channels.with_an_enabled_channel(self.name, client) do |channel|
          channel_who = Channels.channel_who(channel)
          client.emit_ooc "%xn#{channel_who}"
        end
      end
    end  
  end
end