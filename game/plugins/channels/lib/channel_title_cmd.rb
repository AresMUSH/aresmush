module AresMUSH
  module Channels
    class ChannelTitleCmd
      include CommandHandler
           
      attr_accessor :name, :title

      def crack!
        cmd.crack_args!(ArgParser.arg1_equals_optional_arg2)
        self.name = titleize_input(cmd.args.arg1)
        self.title = trim_input(cmd.args.arg2)
      end
      
      def required_args
        {
          args: [ self.name ],
          help: 'channels'
        }
      end
      
      def handle
        Channels.with_an_enabled_channel(self.name, client, enactor) do |channel|
          options = Channels.get_channel_options(enactor, channel)
          options.update(title: self.title)
          client.emit_success t('channels.title_set')
        end
      end
    end  
  end
end