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
        text = "%xh#{t('friends.friends_header')}%xn"
        text << "%R%l2"
        
        client.char.friends.sort_by { |c| c.name }.each do |f| 
          if (Global.client_monitor.find_client(f))
            connected = t('friends.connected')
          else
            connected = OOCTime.local_long_timestr(client, f.last_on)
          end
          text << "%R#{f.name.ljust(25)} #{connected}"
        end
        
        text << "%R%l1%R"
        text << "%xh#{t('friends.handle_friends_header')}%xn"
        text << "%R%l2"
        
        client.char.handle_friends.each do |f|
          visible_alts = Handles.find_visible_alts(f, client.char)
          if (visible_alts.any?)
            text << "%R#{f.ljust(25)} #{visible_alts.map { |a| a.name }.join(" ")}"
          else
            text << "%R#{f.ljust(25)} --"
          end
        end
        
        client.emit BorderedDisplay.text text
      end
    end
  end
end
