module AresMUSH
  module Channels
    class ChannelTalkCmd
      include Plugin
      include PluginRequiresLogin
      include PluginWithoutSwitches
           
      attr_accessor :channel, :msg, :alias

      def want_command?(client, cmd)
        return false if !client.logged_in?
        self.alias = cmd.root
        self.channel = Channels.channel_for_alias(client.char, self.alias)
        !self.channel.nil?
      end
            
      def crack!
        self.msg = cmd.args
      end
      
      def handle
        # To support MUX-style command syntax, messages can trigger other
        # commands.
        cmd = nil
        if (self.msg == "who")
          cmd = Command.new("channel/who #{self.channel.name}")
        elsif (self.msg == "on")
          cmd = Command.new("channel/join #{self.channel.name}=#{self.alias}")
          return
        elsif (self.msg == "off")
          cmd = Command.new("channel/leave #{self.channel.name}")
        elsif (self.msg == "gag")
          cmd = Command.new("channel/gag #{self.channel.name}")
        elsif (self.msg == "ungag")
          cmd = Command.new("channel/ungag #{self.channel.name}")
        end
        
        if (!cmd.nil?)
          Global.dispatcher.queue_command(client, cmd)
          return
        end

        if (!Channels.is_on_channel?(client.char, self.channel))
          client.emit_failure t('channels.not_on_channel')
          return
        end
          
        title = Channels.get_channel_option(client.char, channel, "title")
        name = title.nil? ? client.char.ooc_name : "#{title} #{client.char.ooc_name}"
        self.channel.pose(name, self.msg)
      end
    end  
  end
end