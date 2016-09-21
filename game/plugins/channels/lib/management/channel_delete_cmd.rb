module AresMUSH
  module Channels
    class ChannelDeleteCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
           
      attr_accessor :name
      
      def initialize
        self.required_args = ['name']
        self.help_topic = 'channels'
        super
      end
      
      def crack!
        self.name = titleize_input(cmd.args)
      end
      
      def check_can_manage
        return t('dispatcher.not_allowed') if !Channels.can_manage_channels?(client.char)
        return nil
      end
      
      def handle
        Channels.with_a_channel(name, client) do |channel|
          channel.emit t('channels.channel_being_deleted', :name => client.name)
          channel.destroy
          client.emit_success t('channels.channel_deleted')
        end
      end
    end
  end
end
