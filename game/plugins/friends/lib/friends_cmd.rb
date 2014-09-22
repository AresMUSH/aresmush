module AresMUSH
  module Friends
    class FriendsCmd
      include Plugin
      include PluginWithoutSwitches
      include PluginRequiresLogin
      
      def want_command?(client, cmd)
        cmd.root_is?("friends") && cmd.switch.nil?
      end
      
      def handle
        text = t('friends.friends_title')
        text << "%R%R"
        text << t('friends.friends_header')
        text << "%R%l2"
        
        client.char.friends.sort_by { |c| c.name }.each do |f| 
          if (Global.client_monitor.find_client(f))
            connected = t('friends.connected')
          else
            connected = OOCTime.local_time_str(client, f.last_on)
          end
          text << "%R#{f.name.ljust(25)} #{connected}"
        end
        
        client.emit BorderedDisplay.text text
      end
    end
  end
end
