module AresMUSH
  module Channels
    class ChannelTitleCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
           
      attr_accessor :name, :title

      def initialize
        self.required_args = ['name']
        self.help_topic = 'channels'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("channel") && cmd.switch_is?("title")
      end
            
      def crack!
        cmd.crack!(CommonCracks.arg1_equals_arg2)
        self.name = titleize_input(cmd.args.arg1)
        self.title = trim_input(cmd.args.arg2)
      end
      
      def handle
        Channels.with_an_enabled_channel(self.name, client) do |channel|
          Channels.set_channel_option(client.char, channel, "title", self.title)
          client.char.save!
          client.emit_success t('channels.title_set')
        end
      end
    end  
  end
end