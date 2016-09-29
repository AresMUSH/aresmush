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
        Global.client_monitor.logged_in_clients.each do |other_client|
          common_channels = Channels.find_common_channels(channels, other_client)
          if (common_channels)
            other_client.emit "#{common_channels} #{t('channels.has_connected', :name => char.name)}"
          end
        end

        if (Login::Api.is_guest?(char))
          Channels.add_to_default_channels(client, char)
        end
      end
    end
    
    class CharDisconnectedEventHandler
      def on_event(event)
        client = event.client
        char = event.char
        channels = char.channels
        
        Global.client_monitor.logged_in_clients.each do |other_client|
          common_channels = Channels.find_common_channels(channels, other_client)
          if (common_channels)
            other_client.emit "#{common_channels} #{t('channels.has_disconnected', :name => char.name)}"
          end
        end
        
        channels.each do |c|
          Channels.set_gagging(char, c, false)
        end
        char.save!        
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
  end
end
