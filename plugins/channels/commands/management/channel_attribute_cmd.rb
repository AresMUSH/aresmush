module AresMUSH
  module Channels
    module ChannelAttributeCmd
      include CommandHandler
           
      attr_accessor :name, :attribute

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.name = titlecase_arg(args.arg1)
        self.attribute = trim_arg(args.arg2)
      end
      
      def required_args
        [ self.name, self.attribute ]
      end
      
      def check_can_manage
        return t('dispatcher.not_allowed') if !Channels.can_manage_channels?(enactor)
        return nil
      end
    end
  
    class ChannelRenameCmd
      include ChannelAttributeCmd
    
      def handle
        other_channel = Channel.named(self.attribute)
        Channels.with_a_channel(name, client) do |channel|
          if (other_channel && other_channel != channel)
            client.emit_failure t('channels.channel_already_exists', :name => self.attribute)
            return
          end
          
          channel.update(name: self.attribute)
          client.emit_success "%xn#{t('channels.channel_renamed', :old_name => self.name, :new_name => Channels.display_name(nil, channel))}"
        end
      end
    end
    
    class ChannelDefaultColorCmd
      include ChannelAttributeCmd
    
      def handle
        Channels.with_a_channel(name, client) do |channel|
          channel.update(color: self.attribute)
          client.emit_success "%xn#{t('channels.default_color_set', :name => Channels.display_name(nil, channel))}"
        end
      end
    end
    
    class ChannelDescCmd
      include ChannelAttributeCmd
    
      def handle
        Channels.with_a_channel(name, client) do |channel|        
          channel.update(description: self.attribute)
          client.emit_success t('channels.desc_set')
        end
      end
    end
    
    class ChannelRolesCmd
      include ChannelAttributeCmd
    
      def check_roles
        roles.each do |r|
          return t('channels.invalid_channel_role', :name => r) if !Role.found?(r)
        end
        return nil
      end
      
      def roles
        if (self.attribute == "none" || !self.attribute)
          return []
        end
        self.attribute.split(",").map { |r| trim_arg(r) }
      end
    
      def handle
        Channels.with_a_channel(name, client) do |channel|
        
          if (cmd.switch_is?("joinroles"))
            channel.set_roles(roles, :join)
          else
            channel.set_roles(roles, :talk)
          end
        
          Channels.emit_to_channel channel, t('channels.roles_changed_by', :name => enactor_name)
        
          channel.characters.each do |c|
            if (!Channels.can_join_channel?(c, channel))
              Channels.leave_channel(c, channel)
            end
          end
          client.emit_success t('channels.roles_set')
        end
      end
    end
    
    class ChannelDefaultAlias
      include ChannelAttributeCmd
    
      def handle
        Channels.with_a_channel(name, client) do |channel|
          channel.update(default_alias: self.attribute.split(/[, ]/))
          client.emit_success t('channels.default_alias_set', :alias => channel.default_alias.join(", "))
        end
      end
    end
    
  end
end
