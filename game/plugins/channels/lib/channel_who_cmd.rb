module AresMUSH
  module Channels
    class ChannelWhoCmd
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
        cmd.root_is?("channel") && cmd.switch_is?("who")
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
        
        channel_who = Channels.channel_who(channel)
        client.emit "%% #{channel_who}"
      end
    end  
  end
end