module AresMUSH
  module Channels
    class ChannelShowTitlesCmd
      include CommandHandler
           
      attr_accessor :option, :name

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.name = titlecase_arg(args.arg1)
        self.option = OnOffOption.new(args.arg2)
      end
      
      def required_args
        [ self.option, self.name ]
      end
      
      def check_option
        return self.option.validate
      end
  
      def handle
        Channels.with_an_enabled_channel(self.name, client, enactor) do |channel|
          channel_options = Channels.get_channel_options(enactor, channel)
          show_titles = self.option.is_on?
          channel_options.update(show_titles: show_titles)

          if show_titles
            client.emit_success t('channels.channel_titles_enabled', :name => channel.name)
          else
            client.emit_success t('channels.channel_titles_disabled', :name => channel.name)
          end
        end
      end
    end

  end
end