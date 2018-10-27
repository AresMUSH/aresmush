module AresMUSH
  module Channels   
    class CharConnectedEventHandler
      def on_event(event)
        client = event.client
        char = Character[event.char_id]
        channels = char.channels

        Global.client_monitor.logged_in.each do |other_client, other_char|
          next if other_char == char
          common_channels = Channels.find_common_channels(channels, other_char)
          if (common_channels)
           other_client.emit "#{common_channels} #{t('channels.has_connected', :name => char.ooc_name)}"
          end
        end

        if (char.is_guest?)
          channels = Global.read_config("channels", "default_channels")          
          Channels.add_to_channels(client, char, channels)
          client.emit_success t('channels.channel_command_hint')
        end
      end
    end
  end
end
