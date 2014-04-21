module AresMUSH
  module Channels
    class ChannelWhoCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
           
      attr_accessor :name

      def initialize
        self.required_args = ['name']
        self.help_topic = 'channels'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("channel") && cmd.switch_is?("who")
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