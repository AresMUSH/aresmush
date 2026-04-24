module AresMUSH
  module Channels
    class ChannelAnnounceCmd
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
        if (self.name.downcase == "all")
          enactor.channels.each do |c|
            set_channel_announce(c.name)
          end
        else
          set_channel_announce(self.name)
        end
      end
      
      def set_channel_announce(channel_name)
        Channels.with_an_enabled_channel(channel_name, client, enactor) do |channel|
          options = Channels.get_channel_options(enactor, channel)
        
          announce_on = self.option.is_on?        
          options.update(announce: announce_on)
        
          if (announce_on)
            client.emit_success "%xn#{t('channels.announce_enabled', :name => Channels.display_name(enactor, channel))}"
          else
            client.emit_success "%xn#{t('channels.announce_disabled', :name => Channels.display_name(enactor, channel))}"
          end          
        end
      end
    end
  end
end