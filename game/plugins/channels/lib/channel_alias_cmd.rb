module AresMUSH
  module Channels
    class ChannelAliasCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
           
      attr_accessor :name, :alias

      def initialize
        self.required_args = ['name', 'alias']
        self.help_topic = 'channels'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("channel") && cmd.switch_is?("alias")
      end
            
      def crack!
        cmd.crack_args!(CommonCracks.arg1_equals_arg2)
        self.name = titleize_input(cmd.args.arg1)
        self.alias = trim_input(cmd.args.arg2)
      end
      
      
      def handle
        Channels.with_an_enabled_channel(self.name, client) do |channel|
          Channels.set_channel_alias(client, client.char, channel, self.alias)
        end
      end
    end  
  end
end