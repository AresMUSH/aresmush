module AresMUSH
  module Channels
    class ChannelInfoCmd
      include CommandHandler
           
      attr_accessor :name

      def parse_args
        self.name = titlecase_arg(cmd.args)
      end
          
      def required_args
        [ self.name ]
      end
        
      def handle
        Channels.with_a_channel(self.name, client) do |channel|
          template = ChannelInfoTemplate.new(channel, enactor)
          client.emit template.render
        end
      end
    end
  end
end
