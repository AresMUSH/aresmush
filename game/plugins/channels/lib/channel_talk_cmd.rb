module AresMUSH
  module Channels
    class ChannelTalkCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandWithoutSwitches
           
      attr_accessor :channel, :msg
      
      def crack!
        self.msg = cmd.args
      end
      
      def log_command
        # Don't log channel chat
      end
      
      def handle
        self.channel = Channels.channel_for_alias(enactor, cmd.root)
        
        # To support MUX-style command syntax, messages can trigger other
        # commands.
        cmd = nil
        if (self.msg == "who")
          cmd = Command.new("channel/who #{self.channel.name}")
        elsif (self.msg == "on")
          chan_alias = Channels.get_channel_option(enactor, self.channel, 'alias')
          if (chan_alias)
            cmd = Command.new("channel/join #{self.channel.name}=#{chan_alias.join(",")}")
          else
            cmd = Command.new("channel/join #{self.channel.name}")
          end          
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

        if (!Channels.is_on_channel?(enactor, self.channel))
          client.emit_failure t('channels.not_on_channel')
          return
        end
        
        if (Channels.is_gagging?(enactor, self.channel))
          client.emit_failure t('channels.cant_talk_when_gagged')
          return          
        end
          
        title = Channels.get_channel_option(enactor, channel, "title")
        ooc_name = Handles::Api.ooc_name(enactor)
        name = title.nil? ? ooc_name : "#{title} #{ooc_name}"
        self.channel.pose(name, self.msg)
      end
    end  
  end
end