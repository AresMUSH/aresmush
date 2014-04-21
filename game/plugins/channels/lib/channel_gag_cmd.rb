module AresMUSH
  module Channels
    class ChannelGagCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
           
      attr_accessor :name

      def initialize
        self.required_args = ['name']
        self.help_topic = 'channels'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("channel") && (cmd.switch_is?("gag") || cmd.switch_is?("ungag"))
      end
            
      def crack!
        self.name = titleize_input(cmd.args)
      end
      
      def handle
        Channels.with_an_enabled_channel(self.name, client) do |channel|
          if (cmd.switch_is?("gag"))
            Channels.set_gagging(client.char, channel, true)
            client.emit_success t('channels.channel_gagged', :name => self.name)
          else
            Channels.set_gagging(client.char, channel, false)
            client.emit_success t('channels.channel_ungagged', :name => self.name)
          end
          client.char.save!
        end
      end
    end  
  end
end