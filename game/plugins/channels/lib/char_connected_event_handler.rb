module AresMUSH
  module Channels   
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
          client.emit_success t('channels.channel_command_hint')
        end
      end
    end
  end
end
