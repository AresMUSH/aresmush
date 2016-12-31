module AresMUSH
  module Channels
    class CharCreatedEventHandler
      def on_event(event)
        Channels.add_to_default_channels(event.client, event.char)
      end
    end
    
    class CharConnectedEventHandler
      def on_event(event)
        client = event.client
        char = event.char
        channels = char.channels

        Global.client_monitor.logged_in.each do |other_client, other_char|
          next if other_char == event.char
          common_channels = Channels.find_common_channels(channels, other_char)
          if (common_channels)
           other_client.emit "#{common_channels} #{t('channels.has_connected', :name => char.ooc_name)}"
          end
        end

        if (char.is_guest?)
          Channels.add_to_default_channels(client, char)
        end
      end
    end
    
    class CharDisconnectedEventHandler
      def on_event(event)
        client = event.client
        char = event.char
        channels = char.channels
        
        Global.client_monitor.logged_in.each do |other_client, other_char|
          common_channels = Channels.find_common_channels(channels, other_char)
          if (common_channels)
            other_client.emit "#{common_channels} #{t('channels.has_disconnected', :name => char.ooc_name)}"
          end
        end
        
        channels.each do |c|
          Channels.set_gagging(char, c, false)
        end
      end
    end
    
    class RolesChangedEventHandler
      def on_event(event)
        char = event.char
        char.channels.each do |channel|
          if (!Channels.can_use_channel(char, channel))        
            Channels.leave_channel(char, channel)
          end
        end
      end
    end
    
    class RolesDeletedEventHandler
      def on_event(event)
        Channel.all.each do |channel|
          channel.roles.each do |r|
            if (r.id == event.role_id)
              Global.logger.debug "Deleting role from channel #{channel.name}."
              channel.roles.delete r
            end
          end
        end
      end
    end
  end
end
