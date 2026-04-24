module AresMUSH
  module Channels   
    class CharConnectedEventHandler
      def on_event(event)
        client = event.client
        char = Character[event.char_id]
        channels = char.channels

        # Don't announce web connections.
        return if !client
        
        Global.client_monitor.client_to_char_map.each do |other_client, other_char|
          next if other_char == char
          common_channels = Channels.find_common_channels(channels, other_char)
          
          if (common_channels)
           other_client.emit "#{common_channels} #{t('channels.has_connected', :name => char.ooc_name)}"
          end
        end
      end
    end
  end
end
