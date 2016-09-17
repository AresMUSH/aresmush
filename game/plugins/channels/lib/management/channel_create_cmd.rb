module AresMUSH
  module Channels
    class ChannelCreateCmd
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
        cmd.root_is?("channel") && cmd.switch_is?("create")
      end
      
      def crack!
        self.name = titleize_input(cmd.args)
      end
      
      def check_can_manage
        return t('dispatcher.not_allowed') if !Channels.can_manage_channels?(client.char)
        return nil
      end
      
      def check_channel_exists
        return t('channels.channel_already_exists', :name => self.name) if Channel.found?(self.name.upcase)
        return nil
      end
      
      def handle
        channel = Channel.create(name: self.name)
        client.emit_success t('channels.channel_created', :alias => channel.default_alias.join(",") )
      end
    end
  end
end
