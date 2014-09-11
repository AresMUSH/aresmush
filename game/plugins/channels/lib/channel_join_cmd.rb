module AresMUSH
  module Channels
    class ChannelJoinCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
           
      attr_accessor :name, :alias

      def initialize
        self.required_args = ['name']
        self.help_topic = 'channels'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("channel") && cmd.switch_is?("join")
      end
      
      def crack!
        cmd.crack_args!(CommonCracks.arg1_equals_optional_arg2)
        self.name = titleize_input(cmd.args.arg1)
        self.alias = trim_input(cmd.args.arg2)
      end
            
      def handle
        Channels.join_channel(self.name, client, client.char, self.alias)
      end
    end
  end
end
