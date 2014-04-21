module AresMUSH
  module Channels
    class LoginEvents
      include Plugin
      
      def on_char_connected_event(event)
        client = event.client
        channels = client.char.channels
        Global.client_monitor.clients.each do |other_client|
          common_channels = find_common_channels(channels, other_client)
          other_client.emit "#{common_channels} #{t('channels.has_connected', :name => client.name)}"
        end
      end
      
      def on_char_disconnected_event(event)
        client = event.client
        channels = client.char.channels
        
        Global.client_monitor.clients.each do |other_client|
          common_channels = find_common_channels(channels, other_client)
          other_client.emit "#{common_channels} #{t('channels.has_disconnected', :name => client.name)}"
        end
        
        channels.each do |c|
          Channels.set_gagging(client.char, c, false)
        end
        client.char.save!        
      end
      
      def on_roles_changed_event(event)
        char = event.char
        char.channels.each do |channel|
          if (!Channels.can_use_channel(char, channel))        
            Channels.leave_channel(char, channel)
          end
        end
      end
      
      def find_common_channels(channels, other_client)
        their_channels = other_client.char.nil? ? [] : other_client.char.channels
        intersection = channels & their_channels
        intersection = intersection.map { |c| c.display_name(false) }
        Channels.name_with_markers(intersection.join(", "))
      end
    end
  end
end
