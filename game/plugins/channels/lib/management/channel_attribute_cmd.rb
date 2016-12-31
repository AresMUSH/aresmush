module AresMUSH
  module Channels
    module ChannelAttributeCmd
      include CommandHandler
           
      attr_accessor :name, :attribute

      def crack!
        cmd.crack_args!(ArgParser.arg1_equals_arg2)
        self.name = titleize_input(cmd.args.arg1)
        self.attribute = trim_input(cmd.args.arg2)
      end
      
      def required_args
        {
          args: [ self.name, self.attribute ],
          help: 'channels'
        }
      end
      
      def check_can_manage
        return t('dispatcher.not_allowed') if !Channels.can_manage_channels?(enactor)
        return nil
      end
    end
  
    class ChannelRenameCmd
      include ChannelAttributeCmd
    
      def handle
        Channels.with_a_channel(name, client) do |channel|
          channel.update(name: self.attribute)
          client.emit_success "%xn#{t('channels.channel_renamed', :old_name => self.name, :new_name => channel.display_name)}"
        end
      end
    end
    
    class ChannelColorCmd
      include ChannelAttributeCmd
    
      def handle
        Channels.with_a_channel(name, client) do |channel|
          channel.update(color: self.attribute)
          client.emit_success "%xn#{t('channels.color_set', :name => channel.display_name)}"
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
        self.attribute.split(",").map { |r| trim_input(r) }
      end
    
      def handle
        Channels.with_a_channel(name, client) do |channel|
        
          channel.roles.each { |r| channel.roles.delete r }
          
          roles.each do |r|
            roles.each { |r| channel.roles.add Role.find_one_by_name(r) }
          end
        
          channel.emit t('channels.roles_changed_by', :name => enactor_name)
        
          channel.characters.each do |c|
            if (!Channels.can_use_channel(c, channel))
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
          channel.update(default_alias: self.attribute.split(","))
          client.emit_success t('channels.default_alias_set')
        end
      end
    end
    
  end
end
