module AresMUSH
  module Channels
    class ChannelCreateCmd
      include CommandHandler
           
      attr_accessor :name

      def parse_args
        self.name = titlecase_arg(cmd.args)
      end
      
      def required_args
        [ self.name ]
      end
      
      def check_can_manage
        return t('dispatcher.not_allowed') if !Channels.can_manage_channels?(enactor)
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
