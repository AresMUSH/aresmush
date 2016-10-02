module AresMUSH
  module Channels
    class ChannelGagCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
           
      attr_accessor :name
      
      def crack!
        self.name = titleize_input(cmd.args)
      end
      
      def required_args
        {
          args: [ self.name ],
          help: 'channels'
        }
      end
      
      def handle
        Channels.with_an_enabled_channel(self.name, client, enactor) do |channel|
          if (cmd.switch_is?("gag"))
            Channels.set_gagging(enactor, channel, true)
            client.emit_success t('channels.channel_gagged', :name => self.name)
          else
            Channels.set_gagging(enactor, channel, false)
            client.emit_success t('channels.channel_ungagged', :name => self.name)
          end
          enactor.save!
        end
      end
    end  
  end
end