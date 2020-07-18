module AresMUSH
  module Channels
    class ChannelColorCmd
      include CommandHandler
       
      attr_accessor :name, :color

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.name = titlecase_arg(args.arg1)
        self.color = trim_arg(args.arg2)
      end
  
      def required_args
        [ self.name, self.color ]
      end
  
      def handle
        Channels.with_an_enabled_channel(self.name, client, enactor) do |channel|
          options = Channels.get_channel_options(enactor, channel)
          options.update(color: self.color)
          client.emit_success "%xn#{t('channels.color_set', :name => Channels.display_name(enactor, channel))}"
        end
      end
    end

  end
end