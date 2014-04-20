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
        channel = Channel.find_by_name(self.name)

        if (channel.nil?)
          client.emit_failure t('channels.channel_doesnt_exist', :name => self.name) 
          return
        end
                
        if (!channel.characters.include?(client.char))
          client.emit_failure t('channels.not_on_channel')
          return
        end
        
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