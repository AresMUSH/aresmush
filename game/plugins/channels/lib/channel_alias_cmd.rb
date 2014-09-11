module AresMUSH
  module Channels
    class ChannelAliasCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
           
      attr_accessor :name, :alias

      def initialize
        self.required_args = ['name', 'alias']
        self.help_topic = 'channels'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("channel") && cmd.switch_is?("alias")
      end
            
      def crack!
        cmd.crack_args!(CommonCracks.arg1_equals_arg2)
        self.name = titleize_input(cmd.args.arg1)
        self.alias = trim_input(cmd.args.arg2)
      end
      
      
      def handle
        Channels.with_an_enabled_channel(self.name, client) do |channel|
          if (!Channels.channel_for_alias(client.char, self.alias).nil?)
            client.emit_failure t('channels.alias_in_use', :channel_alias => self.alias)
            return
          end
        
          Channels.set_channel_option(client.char, channel, "alias", self.alias)
          client.emit_success t('channels.channel_alias_set', :name => self.name, :channel_alias => self.alias)
          client.char.save!
          
          trimmed_alias = CommandCracker.strip_prefix(self.alias)
          if (trimmed_alias.nil? || trimmed_alias.length < 2)
            client.emit_success t('channels.short_alias_warning')
          end
        end
      end
    end  
  end
end