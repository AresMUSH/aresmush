module AresMUSH
  module Channels
    class ChannelGagCmd
      include CommandHandler
           
      attr_accessor :name
      
      def parse_args
        self.name = titlecase_arg(cmd.args)
      end
      
      def required_args
        {
          args: [ self.name ],
          help: 'channels'
        }
      end
      
      def handle
        if (self.name.downcase == "all")
          enactor.channels.each do |c|
            gag_channel(c.name)
          end
        else
          gag_channel(self.name)
        end
        
      end
      
      def gag_channel(channel_name)
        Channels.with_an_enabled_channel(channel_name, client, enactor) do |channel|
          if (cmd.switch_is?("gag"))
            Channels.set_gagging(enactor, channel, true)
            client.emit_success t('channels.channel_gagged', :name => channel_name)
          else
            Channels.set_gagging(enactor, channel, false)
            client.emit_success t('channels.channel_ungagged', :name => channel_name)
          end
        end
      end
    end  
  end
end