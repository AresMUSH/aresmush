module AresMUSH
  module Channels
    class ChannelForceLeaveCmd
      include CommandHandler

      attr_accessor :char_name, :channel_name
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.char_name = titlecase_arg(args.arg1)
        self.channel_name = titlecase_arg(args.arg2)
      end
      
      def required_args
        [ self.char_name, self.channel_name ]
      end
      
      def check_can_manage
        return t('dispatcher.not_allowed') if !Channels.can_manage_channels?(enactor)
        return nil
      end      
      
      def handle
        ClassTargetFinder.with_a_character(self.char_name, client, enactor) do |model|
          Channels.with_an_enabled_channel(self.channel_name, client, model) do |channel|
            other_client = Login.find_client(model)
            if (other_client)
              other_client.emit_ooc t('channels.force_removed', :char => enactor_name, :channel => channel.name)
            end
            Channels.leave_channel(model, channel)
            client.emit_success t('channels.char_removed_from_channel', :char => model.name, :channel => channel.name)
          end
        end
      end
    end
  end
end