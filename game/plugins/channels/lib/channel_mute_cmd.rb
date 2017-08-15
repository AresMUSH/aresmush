module AresMUSH
  module Channels
    class ChannelMuteCmd
      include CommandHandler
           
      attr_accessor :name
      
      def parse_args
        self.name = titlecase_arg(cmd.args)
      end
      
      def required_args
        [ self.name ]
      end
      
      def handle
        if (self.name.downcase == "all")
          enactor.channels.each do |c|
            mute_channel(c.name)
          end
        else
          mute_channel(self.name)
        end
        
      end
      
      def mute_channel(channel_name)
        Channels.with_an_enabled_channel(channel_name, client, enactor) do |channel|
          if (cmd.switch_is?("mute"))
            Channels.set_muted(enactor, channel, true)
            client.emit_success t('channels.channel_muted', :name => channel_name)
          else
            Channels.set_muted(enactor, channel, false)
            client.emit_success t('channels.channel_unmuted', :name => channel_name)
          end
        end
      end
    end  
  end
end