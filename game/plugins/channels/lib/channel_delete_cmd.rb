module AresMUSH
  module Channels
    class ChannelDeleteCmd
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
        cmd.root_is?("channel") && cmd.switch_is?("delete")
      end
      
      def crack!
        self.name = titleize_input(cmd.args)
      end
      
      def check_can_manage
        return t('dispatcher.not_allowed') if !Channels.can_manage_channels?(client.char)
        return nil
      end
      
      def handle
        channel = Channel.find_by_name(self.name)
        
        if (channel.nil?)
          client.emit_failure t('channels.channel_doesnt_exist', :name => self.name) 
          return
        end
        
        channel.emit t('channels.channel_being_deleted', :name => client.name)
        channel.destroy
        client.emit_success t('channels.channel_deleted')
      end
    end
  end
end
