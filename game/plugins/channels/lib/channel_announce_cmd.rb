module AresMUSH
  module Channels
    class ChannelAnnounceCmd
      include CommandHandler
           
      attr_accessor :option, :name

      def crack!
        cmd.crack_args!(CommonCracks.arg1_equals_arg2)
        self.name = titleize_input(cmd.args.arg1)
        self.option = OnOffOption.new(cmd.args.arg2)
      end
      
      def required_args
        {
          args: [ self.option, self.name ],
          help: 'channels'
        }
      end
      
      def check_option
        return self.option.validate
      end
  
      def handle
        Channels.with_an_enabled_channel(self.name, client, enactor) do |channel|
          options = Channels.get_channel_options(enactor, channel)
          
          announce_on = self.option.is_on?
          
          # Mute logic works backwards!
          if (cmd.switch_is?("mute"))
            announce_on = !announce_on
          end
          options.update(announce: announce_on)
          
          if (announce_on)
            client.emit_success "%xn#{t('channels.announce_enabled', :name => channel.display_name)}"
          else
            client.emit_success "%xn#{t('channels.announce_disabled', :name => channel.display_name)}"
          end          
        end
      end
    end

  end
end