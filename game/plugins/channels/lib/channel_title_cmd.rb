module AresMUSH
  module Channels
    class ChannelTitleCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
           
      attr_accessor :name, :title

      def initialize(client, cmd, enactor)
        self.required_args = ['name']
        self.help_topic = 'channels'
        super
      end
            
      def crack!
        cmd.crack_args!(CommonCracks.arg1_equals_optional_arg2)
        self.name = titleize_input(cmd.args.arg1)
        self.title = trim_input(cmd.args.arg2)
      end
      
      def handle
        Channels.with_an_enabled_channel(self.name, client) do |channel|
          Channels.set_channel_option(enactor, channel, "title", self.title)
          enactor.save!
          client.emit_success t('channels.title_set')
        end
      end
    end  
  end
end