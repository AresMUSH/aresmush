module AresMUSH
  module Channels
    module ChannelAttributeCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
           
      attr_accessor :name, :attribute

      def initialize
        self.required_args = ['name', 'attribute']
        self.help_topic = 'channels'
        super
      end
      
      def crack!
        cmd.crack!(CommonCracks.arg1_equals_arg2)
        self.name = titleize_input(cmd.args.arg1)
        self.attribute = trim_input(cmd.args.arg2)
      end
      
      def check_can_manage
        return t('dispatcher.not_allowed') if !Channels.can_manage_channels?(client.char)
        return nil
      end
    end
  
    class ChannelAnsiCmd
      include ChannelAttributeCmd
    
      def want_command?(client, cmd)
        cmd.root_is?("channel") && cmd.switch_is?("ansi")
      end
    
      def handle
        Channels.with_a_channel(name, client) do |channel|
          channel.ansi = self.attribute
          channel.save!
          client.emit_success t('channels.ansi_set', :name => channel.display_name)
        end
      end
    end
  
    class ChannelDescCmd
      include ChannelAttributeCmd
    
      def want_command?(client, cmd)
        cmd.root_is?("channel") && cmd.switch_is?("describe")
      end
    
      def handle
        Channels.with_a_channel(name, client) do |channel|        
          channel.description = self.attribute
          channel.save!
          client.emit_success t('channels.desc_set')
        end
      end
    end
    
    class ChannelRolesCmd
      include ChannelAttributeCmd
    
      def want_command?(client, cmd)
        cmd.root_is?("channel") && cmd.switch_is?("roles")
      end
    
      def check_roles
        if (self.attribute == "none" || self.attribute.nil?)
          return nil
        end
        self.attribute.split(",").each do |r|
          return t('channels.invalid_channel_role', :name => r) if !Roles.valid_role?(r)
        end
        return nil
      end
    
      def handle
        Channels.with_a_channel(name, client) do |channel|
        
          if (self.attribute == "none")
            channel.roles = []
          else
            channel.roles = self.attribute.split(",")
          end
        
          channel.emit t('channels.roles_changed_by', :name => client.name)
        
          channel.characters.each do |c|
            if (!Channels.can_use_channel(c, channel))
              Channels.leave_channel(c, channel)
            end
          end
          channel.save!
          client.emit_success t('channels.roles_set')
        end
      end
    end
  end
end
