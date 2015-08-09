module AresMUSH
  module Friends
    class FriendsCmd
      include Plugin
      include PluginWithoutSwitches
      include PluginRequiresLogin
      
      def want_command?(client, cmd)
        cmd.root_is?("friend") && cmd.switch.nil?
      end
      
      def handle
        text = "%xh#{t('friends.friends_header')}%xn"
        text << "%R%l2"
        
        client.char.friendships.sort_by { |f| f.friend.name }.each do |f| 
          friend_char = f.friend
          if (friend_char.client)
            connected = t('friends.connected')
          else
            connected = OOCTime.local_long_timestr(client, friend_char.last_on)
          end
          text << "%R#{friend_char.name.ljust(25)} #{connected}"
          
          if (f.note)
            text << "%R%T#{f.note}"
          end
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
        text << "%R%R"
        text << t('friends.alts_notice')
        
        client.emit BorderedDisplay.text text
      end
    end
  end
end
