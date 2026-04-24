module AresMUSH
  module Channels
    class CharDisconnectedEventHandler
      def on_event(event)
        client = event.client
        char = Character[event.char_id]
        channels = char.channels
        
        Global.client_monitor.client_to_char_map.each do |other_client, other_char|
          common_channels = Channels.find_common_channels(channels, other_char)
          if (common_channels)
            other_client.emit "#{common_channels} #{t('channels.has_disconnected', :name => char.ooc_name)}"
          end
        end
        
        channels.each do |c|
          Channels.set_muted(char, c, false)
        end
      end
    end
  end
end
