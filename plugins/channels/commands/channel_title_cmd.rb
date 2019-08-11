module AresMUSH
  module Channels
    class ChannelTitleCmd
      include CommandHandler
           
      attr_accessor :name, :title
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_optional_arg2)
        self.name = titlecase_arg(args.arg1)
        self.title = trim_arg(args.arg2)
      end
      
      def required_args
        [ self.name ]
      end
      
      def check_permission
        return t('dispatcher.not_allowed') if !enactor.has_permission?('set_comtitle')
        return nil
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