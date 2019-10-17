module AresMUSH
  module Channels
    class ChannelClearCmd
      include CommandHandler
           
      attr_accessor :name
      
      def parse_args
        self.name = trim_arg(cmd.args)
      end
      
      def required_args
        [ self.name ]
      end
      
      def check_can_manage
        return t('dispatcher.not_allowed') if !Channels.can_manage_channels?(enactor)
        return nil
      end
      
      def handle
        Channels.with_a_channel(self.name, client) do |channel|
          channel.update(messages: [])
          client.emit_success t('channels.channel_recall_cleared', :channel => self.name)
        end
      end
    end  
  end
end