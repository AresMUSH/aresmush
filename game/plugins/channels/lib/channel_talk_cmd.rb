module AresMUSH
  module Channels
    class ChannelTalkCmd
      include Plugin
      include PluginRequiresLogin
      include PluginWithoutSwitches
           
      attr_accessor :channel, :msg

      def want_command?(client, cmd)
        return false if !client.logged_in?
        name = "#{cmd.prefix}#{cmd.root}"
        self.channel = Channels.channel_for_alias(client.char, name)
        !self.channel.nil?
      end
            
      def crack!
        self.msg = cmd.args
      end
      
      def handle
        if (!self.channel.characters.include?(client.char))
          client.emit_failure t('channels.not_on_channel')
          return
        end

        title = Channels.get_channel_option(client.char, channel, "title")
        name = title.nil? ? client.name : "#{title} #{client.name}"
        self.channel.pose(name, self.msg)
      end
    end  
  end
end