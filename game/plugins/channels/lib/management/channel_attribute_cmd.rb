module AresMUSH
  module Channels
    module ChannelAttributeCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
           
      attr_accessor :name, :attribute

      def crack!
        cmd.crack_args!(CommonCracks.arg1_equals_arg2)
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
  
    class ChannelColorCmd
      include ChannelAttributeCmd
    
      def handle
        Channels.with_a_channel(name, client) do |channel|
          channel.color = self.attribute
          channel.save!
          client.emit_success "%xn#{t('channels.color_set', :name => channel.display_name)}"
        end
      end
    end
    
    class ChannelAnnounceCmd
      include ChannelAttributeCmd
    
      def check_option
        return nil if self.attribute == 'on'
        return nil if self.attribute == 'off'
        t('channels.invalid_announce_option') 
      end
      
      def handle
        Channels.with_a_channel(name, client) do |channel|
          if (self.attribute == 'on')
            channel.announce = true
            channel.save!
            client.emit_success "%xn#{t('channels.announce_enabled', :name => channel.display_name)}"
          else
            channel.announce = false
            channel.save!
            client.emit_success "%xn#{t('channels.announce_disabled', :name => channel.display_name)}"
          end          
        end
      end
    end
  
    class ChannelDescCmd
      include ChannelAttributeCmd
    
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
    
      def check_roles
        if (self.attribute == "none" || !self.attribute)
          return nil
        end
        self.attribute.split(",").each do |r|
          return t('channels.invalid_channel_role', :name => r) if !Roles::Api.valid_role?(r)
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
        
          channel.emit t('channels.roles_changed_by', :name => enactor_name)
        
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
    
    class ChannelDefaultAlias
      include ChannelAttributeCmd
    
      def handle
        Channels.with_a_channel(name, client) do |channel|
          channel.default_alias = self.attribute.split(",")
          channel.save!
          client.emit_success t('channels.default_alias_set')
        end
      end
    end
    
  end
end
