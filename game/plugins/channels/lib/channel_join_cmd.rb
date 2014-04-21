module AresMUSH
  module Channels
    class ChannelJoinCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
           
      attr_accessor :name, :alias

      def initialize
        self.required_args = ['name']
        self.help_topic = 'channels'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("channel") && cmd.switch_is?("join")
      end
      
      def crack!
        cmd.crack!(/(?<name>[^\=]*)=?(?<alias>.*)/)
        self.name = titleize_input(cmd.args.name)
        self.alias = trim_input(cmd.args.alias)
      end
            
      def handle
        channel = Channel.find_by_name(self.name)
        
        if (channel.nil?)
          client.emit_failure t('channels.channel_doesnt_exist', :name => self.name) 
          return
        end
        
        if (channel.characters.include?(client.char))
          client.emit_failure t('channels.already_on_channel')
          return
        end
        
        if (!Channels.can_use_channel(client.char, channel))
          client.emit_failure t('channels.cant_use_channel')
          return
        end
        
        if (self.alias.empty?)
          self.alias = "+#{self.name[0..2].downcase}"
        end
                
        if (Channels.channel_for_alias(client.char, self.alias) != channel)
          client.emit_failure t('channels.alias_in_use', :channel_alias => self.alias)
          return
        end

        Channels.set_channel_option(client.char, channel, "alias", self.alias)
        client.char.save!
        
        channel.characters << client.char
        channel.save!
        channel.emit t('channels.joined_channel', :name => client.name)
        client.emit_ooc t('channels.channel_alias_set', :name => self.name, :channel_alias => self.alias)
      end
    end
  end
end
