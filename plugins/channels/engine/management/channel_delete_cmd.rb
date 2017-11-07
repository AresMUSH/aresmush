module AresMUSH
  module Channels
    class ChannelDeleteCmd
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
      
      def handle
        Channels.with_a_channel(name, client) do |channel|
          Channels.emit_to_channel channel, t('channels.channel_being_deleted', :name => enactor_name)
          channel.delete
          client.emit_success t('channels.channel_deleted')
        end
      end
    end
  end
end
